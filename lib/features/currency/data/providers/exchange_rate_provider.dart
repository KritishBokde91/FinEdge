import 'dart:convert';
import 'dart:io';

/// Result returned from the exchange rate API fetch operation.
class ExchangeRateFetchResult {
  final String baseCurrency;
  final Map<String, double> rates;
  final String provider;
  final int lastUpdateTimeUnix;
  final int nextUpdateTimeUnix;

  const ExchangeRateFetchResult({
    required this.baseCurrency,
    required this.rates,
    required this.provider,
    required this.lastUpdateTimeUnix,
    required this.nextUpdateTimeUnix,
  });
}

/// Provider querying live exchange rates from public exchange API.
///
/// Ported from ExchangeRateProvider.kt using Dart's native [HttpClient].
class ExchangeRateProvider {
  final HttpClient _client = HttpClient();

  /// Fetches rates for [baseCurrency] from open.er-api.com.
  Future<ExchangeRateFetchResult?> fetchRates(String baseCurrency) async {
    try {
      final uri = Uri.parse('https://open.er-api.com/v6/latest/${baseCurrency.toUpperCase()}');
      final request = await _client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      final jsonString = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;

      if (data['result'] != 'success') {
        return null;
      }

      final rawRates = data['rates'] as Map<String, dynamic>;
      final rates = <String, double>{};
      rawRates.forEach((key, value) {
        if (value is num) {
          rates[key] = value.toDouble();
        }
      });

      return ExchangeRateFetchResult(
        baseCurrency: baseCurrency,
        rates: rates,
        provider: 'open.er-api.com',
        lastUpdateTimeUnix: data['time_last_update_unix'] as int? ?? 0,
        nextUpdateTimeUnix: data['time_next_update_unix'] as int? ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}
