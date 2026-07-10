import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';

/// Base class for Iranian bank parsers.
///
/// Direct port of `parser-core/bank/BaseIranianBankParser.kt`.
/// Handles common Persian language transaction patterns and IRR currency.
abstract class BaseIranianBankParser extends BankParser {
  @override
  String getCurrency() => 'IRR';

  // ---------------------------------------------------------------------------
  // override fun extractAmount(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractAmount(String message) {
    // Pattern 1: "مبلغ 1,500,000 ریال" or "مبلغ 1,500,000 تومان"
    // Pattern 2: amount followed directly by keyword
    final patterns = [
      RegExp(r'مبلغ\s*(\d{1,3}(?:,\d{3})*|\d+)\s*(?:ریال|تومان)'),
      RegExp(r'(\d{1,3}(?:,\d{3})*|\d+)\s*(?:ریال|تومان)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final cleanAmount = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(cleanAmount);
        if (value != null && value >= 1000) return value;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractTransactionType(message): TransactionType?
  // ---------------------------------------------------------------------------

  @override
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();

    if (isInvestmentTransaction(lower)) return TransactionType.investment;

    // Persian expense keywords
    if (lower.contains('برداشت') ||
        lower.contains('پرداخت') ||
        lower.contains('خرید') ||
        lower.contains('انتقال') ||
        lower.contains('مصرف')) {
      return TransactionType.expense;
    }

    // Persian income keywords
    if (lower.contains('واریز') ||
        (lower.contains('credited') && !lower.contains('block'))) {
      return TransactionType.income;
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractMerchant(message, sender): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractMerchant(String message, String sender) {
    final cardPattern = RegExp(r'(\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4})');
    final match = cardPattern.firstMatch(message);
    if (match != null) return 'Card ${match.group(1)}';
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractReference(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractReference(String message) => null;

  // ---------------------------------------------------------------------------
  // override fun extractAccountLast4(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractAccountLast4(String message) {
    super.extractAccountLast4(message)?.let((v) => v)?.let((v) {
      // ignore — Dart does not have Kotlin's ?.let returning; handled below
    });
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final cardPattern = RegExp(r'\d{4}[-\s]?(\d{4})');
    final match = cardPattern.firstMatch(message);
    return match?.group(1);
  }

  // ---------------------------------------------------------------------------
  // override fun extractBalance(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractBalance(String message) {
    // Persian: "مانده: 1,234,567"
    final balancePattern = RegExp(r'مانده\s*:?\s*(\d{1,3}(?:,\d{3})*)');
    final match = balancePattern.firstMatch(message);
    if (match != null) {
      final balStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balStr);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun detectIsCard(message): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool detectIsCard(String message) {
    final lower = message.toLowerCase();
    const cardKeywords = [
      'کارت', 'card', 'debit card', 'credit card', 'کارت بدهی', 'کارت اعتباری',
    ];
    return cardKeywords.any((kw) => lower.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // override fun isTransactionMessage(message): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool isTransactionMessage(String message) {
    final lower = message.toLowerCase();

    // Skip OTP
    if (lower.contains('otp') ||
        lower.contains('رمز یکبار مصرف') ||
        lower.contains('کد تایید')) {
      return false;
    }

    // Skip promotional
    if (lower.contains('تبلیغ') ||
        lower.contains('پیشنهاد') ||
        lower.contains('تخفیف') ||
        lower.contains('cashback offer')) {
      return false;
    }

    // Skip payment requests
    if (lower.contains('درخواست') && lower.contains('پرداخت')) {
      return false;
    }

    const transactionKeywords = [
      'مبلغ', 'ریال', 'تومان', 'IRR', 'TOMAN',
      'برداشت', 'واریز', 'پرداخت', 'خرید', 'انتقال',
      'debit', 'credit', 'spent', 'received', 'transferred', 'paid',
    ];

    return transactionKeywords.any((kw) => lower.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // override fun cleanMerchantName(merchant): String
  // ---------------------------------------------------------------------------

  @override
  String cleanMerchantName(String merchant) => merchant.trim();

  // ---------------------------------------------------------------------------
  // override fun isValidMerchantName(name): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool isValidMerchantName(String name) {
    const commonWords = {
      'USING', 'VIA', 'THROUGH', 'BY', 'WITH', 'FOR', 'TO', 'FROM', 'AT', 'THE',
      // Persian common words
      'استفاده', 'از', 'توسط', 'از طریق', 'برای', 'به', 'در', 'و', 'با',
    };

    return name.length >= 2 &&
        name.split('').any((c) => RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(c)) &&
        !commonWords.contains(name.toUpperCase()) &&
        !RegExp(r'^\d+$').hasMatch(name) &&
        !name.contains('@');
  }
}

// Dart does not have Kotlin's ?.let syntax; this extension provides equivalent.
extension _NullableExt<T> on T? {
  R? let<R>(R? Function(T) block) {
    final v = this;
    if (v != null) return block(v);
    return null;
  }
}
