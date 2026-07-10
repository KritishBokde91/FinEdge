import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart';
import '../../features/currency/data/providers/exchange_rate_provider.dart';
import '../../features/currency/domain/services/currency_conversion_service.dart';

/// Provider exposing exchange rate fetching client.
final exchangeRateProvider = Provider<ExchangeRateProvider>((ref) {
  return ExchangeRateProvider();
});

/// Provider exposing the currency conversion coordinator service.
final currencyConversionServiceProvider = Provider<CurrencyConversionService>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(exchangeRateProvider);
  return CurrencyConversionService(db, api);
});
