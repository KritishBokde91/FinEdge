import 'package:drift/drift.dart';
import '../../../../core/database/drift_database.dart';
import '../../data/providers/exchange_rate_provider.dart';

/// Service coordinating currency lookups, live API fetches, caching, and custom overrides.
///
/// Ported from CurrencyConversionService.kt.
class CurrencyConversionService {
  final AppDatabase _db;
  final ExchangeRateProvider _apiProvider;

  // In-memory cache mapping "FROM_TO" -> Rate Value.
  final Map<String, double> _rateCache = {};

  CurrencyConversionService(this._db, this._apiProvider);

  /// Converts [amount] from [fromCurrency] to [toCurrency].
  Future<double> convertAmount(double amount, String fromCurrency, String toCurrency) async {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();

    if (from == to || amount == 0) return amount;

    final rate = await getRate(from, to);
    if (rate != null) {
      return amount * rate;
    }
    return amount;
  }

  /// Retrieves the exchange rate between [fromCurrency] and [toCurrency].
  ///
  /// Leverages in-memory cache, local SQLite database, and triggers live fetches
  /// on cache miss/stale expires.
  Future<double?> getRate(String fromCurrency, String toCurrency) async {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    final cacheKey = '${from}_$to';

    // 1. Check Cache
    if (_rateCache.containsKey(cacheKey)) {
      return _rateCache[cacheKey];
    }

    // 2. Query Local Database
    final localRate = await _getLocalRate(from, to);
    if (localRate != null) {
      final isExpired = DateTime.now().isAfter(localRate.expiresAt);
      if (!isExpired || localRate.isCustomRate) {
        _rateCache[cacheKey] = localRate.rate;
        return localRate.rate;
      }
    }

    // 3. Rate is expired or missing. Fetch fresh rates from API.
    await refreshRates(from);

    // 4. Return new rate from cache or database fallback
    final freshLocal = await _getLocalRate(from, to);
    if (freshLocal != null) {
      _rateCache[cacheKey] = freshLocal.rate;
      return freshLocal.rate;
    }

    // Fallback to expired rate if API failed
    if (localRate != null) {
      return localRate.rate;
    }

    return null;
  }

  /// Fetches fresh exchange rates for [baseCurrency] and updates local database cache.
  Future<void> refreshRates(String baseCurrency) async {
    final base = baseCurrency.toUpperCase();
    final result = await _apiProvider.fetchRates(base);

    if (result == null) return;

    final updatedAt = DateTime.fromMillisecondsSinceEpoch(result.lastUpdateTimeUnix * 1000);
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(result.nextUpdateTimeUnix * 1000);

    await _db.transaction(() async {
      for (final entry in result.rates.entries) {
        final targetCurrency = entry.key;
        final rate = entry.value;

        // Skip saving identity conversions
        if (targetCurrency == base) continue;

        final existing = await _getLocalRate(base, targetCurrency);
        if (existing != null && existing.isCustomRate) {
          // Preserve custom rates across API refreshes
          continue;
        }

        final id = '$base-$targetCurrency';
        await _db.into(_db.exchangeRatesTable).insert(
              ExchangeRatesTableCompanion(
                id: Value(id),
                fromCurrency: Value(base),
                toCurrency: Value(targetCurrency),
                rate: Value(rate),
                provider: Value(result.provider),
                updatedAt: Value(updatedAt),
                expiresAt: Value(expiresAt),
                isCustomRate: const Value(false),
              ),
              mode: InsertMode.insertOrReplace,
            );

        _rateCache['${base}_$targetCurrency'] = rate;
      }
    });
  }

  /// Sets a custom user exchange rate, bypassing API refreshes.
  Future<void> setCustomRate(String fromCurrency, String toCurrency, double rate) async {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    final id = '$from-$to';
    final farFuture = DateTime.now().add(const Duration(days: 36500)); // 100 years

    await _db.into(_db.exchangeRatesTable).insert(
          ExchangeRatesTableCompanion(
            id: Value(id),
            fromCurrency: Value(from),
            toCurrency: Value(to),
            rate: Value(rate),
            provider: const Value('Custom'),
            updatedAt: Value(DateTime.now()),
            expiresAt: Value(farFuture),
            isCustomRate: const Value(true),
          ),
          mode: InsertMode.insertOrReplace,
        );

    _rateCache['${from}_$to'] = rate;
  }

  /// Clears a custom rate override.
  Future<void> clearCustomRate(String fromCurrency, String toCurrency) async {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    final id = '$from-$to';

    final existing = await _getLocalRate(from, to);
    if (existing != null && existing.isCustomRate) {
      // Revert to non-custom by changing flag to false (expires immediately so next call fetches fresh API rate)
      await _db.into(_db.exchangeRatesTable).insert(
            ExchangeRatesTableCompanion(
              id: Value(id),
              fromCurrency: Value(from),
              toCurrency: Value(to),
              rate: Value(existing.rate),
              provider: Value(existing.provider),
              updatedAt: Value(existing.updatedAt),
              expiresAt: Value(DateTime.now().subtract(const Duration(minutes: 1))),
              isCustomRate: const Value(false),
            ),
            mode: InsertMode.insertOrReplace,
          );
      _rateCache.remove('${from}_$to');
    }
  }

  /// Watches all rates in database.
  Stream<List<ExchangeRatesTableData>> watchAllRates() {
    return _db.select(_db.exchangeRatesTable).watch();
  }

  Future<ExchangeRatesTableData?> _getLocalRate(String from, String to) async {
    final query = _db.select(_db.exchangeRatesTable)
      ..where((t) => t.fromCurrency.equals(from) & t.toCurrency.equals(to));
    return query.getSingleOrNull();
  }
}
