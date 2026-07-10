import 'package:finsight_ai/core/constants/compiled_patterns.dart';
import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';

/// Base abstract class for UAE bank parsers.
///
/// Direct port of `parser-core/bank/UAEBankParser.kt`.
/// Handles common patterns across UAE banks (AED currency, specific transaction
/// types, multi-currency extraction).
abstract class UaeBankParser extends BankParser {
  @override
  String getCurrency() => 'AED';

  // ---------------------------------------------------------------------------
  // protected open fun containsCardPurchase(message): Boolean
  // ---------------------------------------------------------------------------

  /// Checks if the message contains a credit/debit card purchase pattern.
  bool containsCardPurchase(String message) {
    final lower = message.toLowerCase();
    return lower.contains('credit card purchase') ||
        lower.contains('debit card purchase');
  }

  // ---------------------------------------------------------------------------
  // override fun parse(smsBody, sender, timestamp): ParsedTransaction?
  // ---------------------------------------------------------------------------

  /// Parses the message then re-stamps the currency from extractCurrency().
  @override
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    final transaction = super.parse(smsBody, sender, timestamp);
    if (transaction == null) return null;

    final extractedCurrency = extractCurrency(smsBody);
    return extractedCurrency != null
        ? transaction.copyWith(currency: extractedCurrency)
        : transaction;
  }

  // ---------------------------------------------------------------------------
  // override fun extractCurrency(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractCurrency(String message) {
    // Explicit patterns with [A-Z]{3} currency code extraction
    final currencyPatterns = [
      RegExp(r'Amount\s+([A-Z]{3})', caseSensitive: false),
      RegExp(r'\b([A-Z]{3})\s+[0-9,]+(?:\.\d{2})?', caseSensitive: false),
      RegExp(r'for\s+([A-Z]{3})\s+[0-9,]+(?:\.\d{2})?', caseSensitive: false),
      RegExp(r'of\s+([A-Z]{3})\s+[0-9,]+(?:\.\d{2})?', caseSensitive: false),
      RegExp(r'[A-Z]{3}\s+([A-Z]{3})', caseSensitive: false),
    ];

    for (final pattern in currencyPatterns) {
      final found = pattern.firstMatch(message);
      if (found != null) {
        // Check all captured groups starting from 1
        for (int i = 1; i < found.groupCount + 1; i++) {
          final groupVal = found.group(i) ?? '';
          final upperVal = groupVal.toUpperCase();
          if (upperVal.length == 3 &&
              upperVal.split('').every((c) => RegExp(r'[A-Z]').hasMatch(c)) &&
              !_isMonthAbbreviation(upperVal)) {
            return upperVal;
          }
        }
      }
    }

    // Final fallback
    final simplePattern = RegExp(r'\b([A-Z]{3})\s+\d', caseSensitive: false);
    final simpleMatch = simplePattern.firstMatch(message);
    if (simpleMatch != null) {
      final code = simpleMatch.group(1)!.toUpperCase();
      if (!_isMonthAbbreviation(code)) return code;
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractAmount(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractAmount(String message) {
    // Generic multi-currency amount extraction for UAE banks
    // Patterns: "AED 100.00", "USD 50.50", "Purchase of EUR 20.00", etc.
    final isoPattern = CompiledPatterns.currency.isoCode.pattern;
    final patterns = [
      RegExp(
        r'(?:purchase of|transfer of|amount|for|of)\s+(' +
            isoPattern +
            r')\s+([0-9,]+(?:\.\d{2})?)',
        caseSensitive: false,
      ),
      RegExp(
        r'(' + isoPattern + r')\s+([0-9,]+(?:\.\d{2})?)',
        caseSensitive: false,
      ),
      // Masked amount *123.45
      RegExp(
        r'(' + isoPattern + r')\s+\*+([0-9,]+(?:\.\d{2})?)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final currencyCode = match.group(1)!.toUpperCase();
        if (_isMonthAbbreviation(currencyCode)) continue;

        var amountStr = match.group(2)!.replaceAll(',', '');

        // Handle masked amounts (e.g. *123.45 or ***.45)
        if (amountStr.contains('*')) {
          amountStr = amountStr.replaceAll('*', '');
          if (amountStr.isEmpty || amountStr == '.') continue;
        }

        final value = double.tryParse(amountStr);
        if (value != null) return value;
      }
    }

    return super.extractAmount(message);
  }

  // ---------------------------------------------------------------------------
  // override fun extractTransactionType(message): TransactionType?
  // ---------------------------------------------------------------------------

  @override
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();

    // Credit card transactions
    if (lower.contains('credit card purchase')) return TransactionType.credit;
    if (containsCardPurchase(message)) return TransactionType.expense;

    // Cheque transactions
    if (lower.contains('cheque credited')) return TransactionType.income;
    if (lower.contains('cheque returned')) return TransactionType.expense;

    // ATM withdrawals are expenses
    if (lower.contains('atm cash withdrawal') ||
        (lower.contains('atm') && lower.contains('withdrawn'))) {
      return TransactionType.expense;
    }

    // Income transactions
    if (lower.contains('inward remittance')) return TransactionType.income;
    if (lower.contains('cash deposit')) return TransactionType.income;
    if (lower.contains('has been credited')) return TransactionType.income;
    if (lower.contains('is credited')) return TransactionType.income;

    // Outward remittance and payment instructions are expenses
    if (lower.contains('outward remittance')) return TransactionType.expense;
    if (lower.contains('payment instructions')) return TransactionType.expense;
    if (lower.contains('funds transfer request')) return TransactionType.transfer;
    if (lower.contains('has been processed')) return TransactionType.expense;

    // Standard keywords (same guard conditions as Kotlin source)
    if (lower.contains('credit') &&
        !lower.contains('credit card') &&
        !lower.contains('debit') &&
        !lower.contains('purchase') &&
        !lower.contains('payment')) {
      return TransactionType.income;
    }

    if (lower.contains('debit') && !lower.contains('credit')) {
      return TransactionType.expense;
    }
    if (lower.contains('purchase')) return TransactionType.expense;
    if (lower.contains('payment')) return TransactionType.expense;

    return super.extractTransactionType(message);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static const _months = {
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  };

  bool _isMonthAbbreviation(String code) => _months.contains(code);
}


