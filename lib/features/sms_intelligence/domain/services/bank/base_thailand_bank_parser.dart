import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';

/// Base class for Thai bank parsers.
///
/// Direct port of `parser-core/bank/BaseThailandBankParser.kt`.
/// Handles both Thai and English language transaction patterns with THB currency.
abstract class BaseThailandBankParser extends BankParser {
  @override
  String getCurrency() => 'THB';

  // ---------------------------------------------------------------------------
  // override fun extractAmount(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractAmount(String message) {
    // Pattern 1: "1,250.00 THB" or "1,250.00 บาท"
    // Pattern 2: "THB 1,250.00" or "฿ 1,250.00"
    // Pattern 3: "1,250.00 USD" (international transactions)
    final patterns = [
      RegExp(r'(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:THB|บาท)'),
      RegExp(r'(?:THB|฿)\s*(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)'),
      RegExp(r'(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)\s*USD'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final clean = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(clean);
        if (value != null) return value;
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

    // Credit card spending (check before expense — "ยอดใช้จ่าย" contains "ใช้จ่าย")
    if (lower.contains('credit card spending') ||
        lower.contains('ยอดใช้จ่ายต่างประเทศ') ||
        lower.contains('ยอดใช้จ่าย')) {
      return TransactionType.credit;
    }

    // Thai expense keywords
    if (lower.contains('เงินออก') ||
        lower.contains('ถอนเงิน') ||
        lower.contains('ถอนเงินสด') ||
        lower.contains('โอนเงินออก') ||
        lower.contains('โอนเงินผ่าน') ||
        lower.contains('ใช้จ่ายบัตร') ||
        lower.contains('ใช้จ่าย') ||
        // English expense keywords
        lower.contains('withdrawal') ||
        lower.contains('payment') ||
        lower.contains('you spent') ||
        lower.contains('transfer out') ||
        lower.contains('card payment') ||
        lower.contains('card transaction') ||
        lower.contains('atm withdrawal')) {
      return TransactionType.expense;
    }

    // Thai income keywords
    if (lower.contains('เงินเข้า') ||
        lower.contains('เงินฝาก') ||
        lower.contains('รับเงิน') ||
        lower.contains('โอนเงินเข้า') ||
        lower.contains('รับเงินพร้อมเพย์') ||
        lower.contains('รับเงินโอน') ||
        lower.contains('เงินฝากเข้า') ||
        // English income keywords
        lower.contains('deposit') ||
        lower.contains('receive') ||
        lower.contains('transfer in') ||
        lower.contains('transfer received')) {
      return TransactionType.income;
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractBalance(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractBalance(String message) {
    // Thai: "คงเหลือ 15,820.45 บาท" or English: "Bal 15,820.45 THB"
    final patterns = [
      RegExp(
        r'(?:Bal|คงเหลือ)\s+(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:THB|บาท)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:Bal|คงเหลือ)\s+(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final clean = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(clean);
        if (value != null) return value;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractAccountLast4(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    // Pattern: "A/C xNNNN" or "บช xNNNN"
    final pattern = RegExp(r'(?:A/C|บช)\s*x(\d{4})', caseSensitive: false);
    return pattern.firstMatch(message)?.group(1);
  }

  // ---------------------------------------------------------------------------
  // override fun extractMerchant(message, sender): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractMerchant(String message, String sender) {
    // Thai: "ร้าน MERCHANT" or English: "at MERCHANT"
    final patterns = [
      RegExp(
        r'(?:at|ร้าน)\s+([A-Za-z0-9\s&._-]+?)(?:\s+(?:A/C|บช|Bal|คงเหลือ|Available|on|$))',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:at|ร้าน)\s+([A-Za-z0-9\s&._-]+)$',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final name = cleanMerchantName(match.group(1)!.trim());
        if (isValidMerchantName(name)) return name;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractAvailableLimit(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractAvailableLimit(String message) {
    final pattern = RegExp(
      r'(?:Available limit|วงเงินคงเหลือ)\s+(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?)\s*(?:THB|บาท)',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(message);
    if (match != null) {
      final clean = match.group(1)!.replaceAll(',', '');
      return double.tryParse(clean);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun isCreditCardMessage(message): Boolean
  // ---------------------------------------------------------------------------

  bool isCreditCardMessage(String message) {
    final lower = message.toLowerCase();
    const cardKeywords = [
      'credit card', 'บัตรเครดิต',
      'card spending', 'card payment', 'card transaction',
      'ใช้จ่ายบัตร', 'ยอดใช้จ่าย',
    ];
    return cardKeywords.any((kw) => lower.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // override fun isTransactionMessage(message): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool isTransactionMessage(String message) {
    final lower = message.toLowerCase();

    // Skip OTP messages
    if (lower.contains('otp') ||
        lower.contains('รหัส') ||
        lower.contains('ยืนยัน')) {
      return false;
    }

    // Skip promotional messages
    if (lower.contains('สมัคร') ||
        lower.contains('โปรโมชั่น') ||
        lower.contains('promotion') ||
        lower.contains('cashback offer')) {
      return false;
    }

    const transactionKeywords = [
      // Thai
      'เงินเข้า', 'เงินออก', 'ถอนเงิน', 'โอนเงิน', 'ใช้จ่าย',
      'เงินฝาก', 'รับเงิน', 'คงเหลือ', 'บาท', 'ยอดใช้จ่าย',
      // English
      'withdrawal', 'deposit', 'transfer', 'payment', 'spent',
      'receive', 'bal', 'thb', 'card transaction', 'card payment',
      'credit card spending', 'available limit',
    ];

    return transactionKeywords.any((kw) => lower.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // override fun cleanMerchantName / isValidMerchantName
  // ---------------------------------------------------------------------------

  @override
  String cleanMerchantName(String merchant) => merchant.trim();

  @override
  bool isValidMerchantName(String name) {
    const commonWords = {
      'USING', 'VIA', 'THROUGH', 'BY', 'WITH', 'FOR', 'TO', 'FROM', 'AT', 'THE',
      // Thai common words
      'ผ่าน', 'โดย', 'จาก', 'ที่', 'ไปยัง', 'ถึง',
    };

    return name.length >= 2 &&
        name.split('').any((c) => RegExp(r'[a-zA-Z\u0E00-\u0E7F]').hasMatch(c)) &&
        !commonWords.contains(name.toUpperCase()) &&
        !RegExp(r'^\d+$').hasMatch(name) &&
        !name.contains('@');
  }
}
