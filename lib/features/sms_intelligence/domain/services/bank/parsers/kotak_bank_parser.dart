import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Kotak Bank specific parser.
///
/// Direct port of `parser-core/bank/KotakBankParser.kt`.
class KotakBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Kotak Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();

    // DLT patterns for Kotak Bank — covers KOTAKB, KOTAKD, and similar variants
    if (RegExp(r'^[A-Z]{2}-KOTAK[A-Z]-[ST]$').hasMatch(normalizedSender)) {
      return true;
    }

    return normalizedSender.contains('KOTAK');
  }

  @override
  String? extractMerchant(String message, String sender) {
    // IMPS credit from mobile: "linked to mobile xNNNN"
    final mobileLinkedPattern = RegExp(
      r'linked\s+to\s+mobile\s+([xX*]+\d{2,})',
      caseSensitive: false,
    );
    var match = mobileLinkedPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    // Credit card merchant pattern: "on DD-MON-YYYY at MERCHANT. Avl limit"
    final cardMerchantPattern = RegExp(
      r'on\s+\d{1,2}-\w{3}-\d{2,4}\s+at\s+([^.]+?)(?:\.|\s+Avl|$)',
      caseSensitive: false,
    );
    match = cardMerchantPattern.firstMatch(message);
    if (match != null) {
      final rawMerchant = match.group(1)!.trim();
      final merchant = _cleanKotakCardMerchant(rawMerchant);
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    // Try "to" pattern for sent transactions
    final toPattern = RegExp(r'to\s+([^\s]+@[^\s]+)\s+on', caseSensitive: false);
    final fromPattern = RegExp(r'from\s+([^\s]+@[^\s]+)\s+on', caseSensitive: false);

    final upiMatch = toPattern.firstMatch(message) ?? fromPattern.firstMatch(message);

    if (upiMatch != null) {
      final upiId = upiMatch.group(1)!.trim();

      String? merchantName;
      if (upiId.toLowerCase().startsWith('upi')) {
        final remaining = upiId.substring(3);
        final name = remaining.contains('@') ? remaining.split('@').first : remaining;
        if (name.isNotEmpty) {
          merchantName = cleanMerchantName(name);
        }
      } else {
        final parts = upiId.split('@');
        final name = parts.first;
        final bankCode = parts.length > 1 ? parts[1] : '';

        if (_isPaymentAppGeneratedId(name)) {
          merchantName = _extractMerchantFromBankCode(bankCode) ?? cleanMerchantName(name);
        } else if (name.isNotEmpty &&
            (!name.split('').every((c) => '0123456789'.contains(c)) ||
                name.contains('-') ||
                name.contains('_'))) {
          if (name.split('').every((c) => '0123456789-_'.contains(c))) {
            merchantName = _extractMerchantFromBankCode(bankCode) ?? name;
          } else {
            merchantName = cleanMerchantName(name);
          }
        } else if (name.isNotEmpty && name.split('').every((c) => '0123456789'.contains(c))) {
          merchantName = name;
        }
      }

      if (merchantName != null) {
        return merchantName;
      }
    }

    return super.extractMerchant(message, sender);
  }

  String _cleanKotakCardMerchant(String rawMerchant) {
    final upiRefPattern = RegExp(r'^UPI-\d+-(.+)$', caseSensitive: false);
    final match = upiRefPattern.firstMatch(rawMerchant);
    if (match != null) {
      return cleanMerchantName(match.group(1)!.trim());
    }
    return cleanMerchantName(rawMerchant);
  }

  bool _isPaymentAppGeneratedId(String name) {
    final lowerName = name.toLowerCase();

    const generatedIdPrefixes = [
      'paytmqr',
      'phonepeqr',
      'phonepe.qr',
      'gpay',
      'amazonpayqr',
      'bhimqr',
      'bharatpeqr',
      'freechargeqr',
      'mobikwikqr',
    ];

    if (generatedIdPrefixes.any((prefix) => lowerName.startsWith(prefix))) {
      return true;
    }

    if (name.length > 20 &&
        name.split('').any((c) => RegExp(r'[a-zA-Z]').hasMatch(c)) &&
        name.split('').any((c) => RegExp(r'[0-9]').hasMatch(c))) {
      return true;
    }

    return false;
  }

  String? _extractMerchantFromBankCode(String bankCode) {
    switch (bankCode.toLowerCase()) {
      case 'okaxis':
        return 'Axis Bank';
      case 'okbizaxis':
        return 'Axis Bank Business';
      case 'okhdfcbank':
        return 'HDFC Bank';
      case 'okicici':
        return 'ICICI Bank';
      case 'oksbi':
        return 'State Bank of India';
      case 'paytm':
        return 'Paytm';
      case 'ybl':
        return 'PhonePe';
      case 'amazonpay':
        return 'Amazon Pay';
      case 'googlepay':
        return 'Google Pay';
      case 'airtel':
        return 'Airtel Money';
      case 'freecharge':
        return 'Freecharge';
      case 'mobikwik':
        return 'MobiKwik';
      case 'jupiteraxis':
        return 'Jupiter';
      case 'razorpay':
        return 'Razorpay';
      case 'bharatpe':
        return 'BharatPe';
      default:
        return null;
    }
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('avl limit') || lowerMessage.contains('avl lmt')) {
      return TransactionType.credit;
    }

    if (lowerMessage.contains('credit card') &&
        (lowerMessage.contains('spent') || lowerMessage.contains('debited'))) {
      return TransactionType.credit;
    }

    if (lowerMessage.contains('sent rs')) {
      return TransactionType.expense;
    }

    if (lowerMessage.contains('debited')) return TransactionType.expense;
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;
    if (lowerMessage.contains('spent')) return TransactionType.expense;
    if (lowerMessage.contains('charged')) return TransactionType.expense;
    if (lowerMessage.contains('paid')) return TransactionType.expense;
    if (lowerMessage.contains('purchase')) return TransactionType.expense;

    if (lowerMessage.contains('credited')) return TransactionType.income;
    if (lowerMessage.contains('deposited')) return TransactionType.income;
    if (lowerMessage.contains('received')) return TransactionType.income;
    if (lowerMessage.contains('refund')) return TransactionType.income;
    if (lowerMessage.contains('cashback') && !lowerMessage.contains('earn cashback')) {
      return TransactionType.income;
    }

    return null;
  }

  @override
  String? extractReference(String message) {
    final upiRefPatterns = [
      RegExp(r'UPI\s+Ref\s+([0-9]+)', caseSensitive: false),
      RegExp(r'UPI\s+ref\s+no\.?\s+([0-9]+)', caseSensitive: false),
    ];
    for (final pattern in upiRefPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        return match.group(1)!.trim();
      }
    }

    return super.extractReference(message);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final kotakCardPattern = RegExp(
      r'Credit\s+Card\s+[xX*]*(\d{4})',
      caseSensitive: false,
    );
    var match = kotakCardPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final kotakAccountPattern = RegExp(
      r'AC\s+[X*]*([0-9]{4})(?:\s|,|\.)',
      caseSensitive: false,
    );
    match = kotakAccountPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final kotakMaskedAccountPattern = RegExp(
      r'from\s+[xX*]{2,}(\d{4})\b',
      caseSensitive: false,
    );
    match = kotakMaskedAccountPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  @override
  double? extractAvailableLimit(String message) {
    final kotakCreditLimitPatterns = [
      RegExp(r'Avl\s+limit:?\s*INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Avl\s+Lmt:?\s*INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Available\s+limit:?\s*INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    for (final pattern in kotakCreditLimitPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final limitStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(limitStr);
      }
    }

    return super.extractAvailableLimit(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('otp') ||
        lowerMessage.contains('one time password') ||
        lowerMessage.contains('verification code') ||
        lowerMessage.contains('offer') ||
        lowerMessage.contains('discount') ||
        lowerMessage.contains('cashback offer') ||
        lowerMessage.contains('win ')) {
      return false;
    }

    if (lowerMessage.contains('has requested') ||
        lowerMessage.contains('payment request') ||
        lowerMessage.contains('collect request') ||
        lowerMessage.contains('requesting payment') ||
        lowerMessage.contains('requests rs') ||
        lowerMessage.contains('ignore if already paid')) {
      return false;
    }

    const kotakTransactionKeywords = [
      'sent',
      'debited',
      'credited',
      'withdrawn',
      'deposited',
      'spent',
      'received',
      'transferred',
      'paid',
    ];

    return kotakTransactionKeywords.any((kw) => lowerMessage.contains(kw));
  }
}
