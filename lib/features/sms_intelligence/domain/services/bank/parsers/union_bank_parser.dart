import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Union Bank of India SMS messages.
///
/// Direct port of `parser-core/bank/UnionBankParser.kt`.
class UnionBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Union Bank of India';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('UNIONB') ||
        normalizedSender.contains('UNIONBANK') ||
        normalizedSender.contains('UBOI') ||
        RegExp(r'^[A-Z]{2}-UNIONB-[ST]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-UNIONB-[TPG]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-UNIONB$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-UNIONBANK$').hasMatch(normalizedSender);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    // Union Bank includes "Never Share OTP/PIN/CVV" warning in transaction messages
    const transactionKeywords = [
      'debited',
      'credited',
      'withdrawn',
      'deposited',
      'spent',
      'received',
      'transferred',
      'paid',
    ];

    if (transactionKeywords.any((kw) => lowerMessage.contains(kw))) {
      return true;
    }

    return super.isTransactionMessage(message);
  }

  @override
  double? extractAmount(String message) {
    final amountPattern1 = RegExp(
      r'Rs[:.]?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    var match = amountPattern1.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final amountPattern2 = RegExp(
      r'INR\s+([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = amountPattern2.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('mob bk')) {
      return 'Mobile Banking Transfer';
    }

    if (lowerMessage.contains('atm')) {
      final atmPattern = RegExp(
        r'at\s+([^.\s]+(?:\s+[^.\s]+)*)(?:\s+on|\s+Avl|$)',
        caseSensitive: false,
      );
      final m = atmPattern.firstMatch(message);
      if (m != null) {
        return cleanMerchantName(m.group(1)!.trim());
      }
      return 'ATM Withdrawal';
    }

    if (lowerMessage.contains('upi')) {
      final upiPattern = RegExp(r'UPI[/:]?\s*([^,.\s]+)', caseSensitive: false);
      final m = upiPattern.firstMatch(message);
      if (m != null) {
        return cleanMerchantName(m.group(1)!.trim());
      }
    }

    if (lowerMessage.contains('vpa')) {
      final vpaPattern = RegExp(r'VPA\s+([^@\s]+)', caseSensitive: false);
      final m = vpaPattern.firstMatch(message);
      if (m != null) {
        return _parseUPIMerchant(m.group(1)!.trim());
      }
    }

    final toPattern = RegExp(r'to\s+([^.\n]+?)(?:\s+on|\s+Avl|$)', caseSensitive: false);
    final toMatch = toPattern.firstMatch(message);
    if (toMatch != null) {
      final merchant = toMatch.group(1)!.trim();
      if (!merchant.toLowerCase().contains('avl')) {
        return cleanMerchantName(merchant);
      }
    }

    final fromPattern = RegExp(r'from\s+([^.\n]+?)(?:\s+on|\s+Avl|$)', caseSensitive: false);
    final fromMatch = fromPattern.firstMatch(message);
    if (fromMatch != null) {
      final merchant = fromMatch.group(1)!.trim();
      if (!merchant.toLowerCase().contains('avl')) {
        return cleanMerchantName(merchant);
      }
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractReference(String message) {
    final refPatterns = [
      RegExp(r'ref\s+no\s+([\w]+)', caseSensitive: false),
      RegExp(r'ref[:#]?\s*([\w]+)', caseSensitive: false),
      RegExp(r'reference[:#]?\s*([\w]+)', caseSensitive: false),
      RegExp(r'txn[:#]?\s*([\w]+)', caseSensitive: false),
    ];

    for (final pattern in refPatterns) {
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

    final accountPatterns = [
      RegExp(r'A/[Cc]\s*[*X](\d{4})', caseSensitive: false),
      RegExp(r'Account\s*[*X](\d{4})', caseSensitive: false),
      RegExp(r'Acc\s*[*X](\d{4})', caseSensitive: false),
      RegExp(r'A/[Cc]\s+(\d{4})', caseSensitive: false),
    ];

    for (final pattern in accountPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final balancePatterns = [
      RegExp(r'Avl\s+Bal\s+Rs[:.]?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(
        r'Available\s+Balance[:.]?\s*Rs[:.]?\s*([0-9,]+(?:\.\d{2})?)',
        caseSensitive: false,
      ),
      RegExp(r'Balance[:.]?\s*Rs[:.]?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Bal[:.]?\s*Rs[:.]?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    for (final pattern in balancePatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final balanceStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(balanceStr);
      }
    }

    return super.extractBalance(message);
  }

  String _parseUPIMerchant(String vpa) {
    final cleanVPA = vpa.toLowerCase();

    if (cleanVPA.contains('paytm')) return 'Paytm';
    if (cleanVPA.contains('phonepe')) return 'PhonePe';
    if (cleanVPA.contains('googlepay') || cleanVPA.contains('gpay')) return 'Google Pay';
    if (cleanVPA.contains('bharatpe')) return 'BharatPe';
    if (cleanVPA.contains('amazon')) return 'Amazon';
    if (cleanVPA.contains('flipkart')) return 'Flipkart';
    if (cleanVPA.contains('swiggy')) return 'Swiggy';
    if (cleanVPA.contains('zomato')) return 'Zomato';
    if (cleanVPA.contains('uber')) return 'Uber';
    if (cleanVPA.contains('ola')) return 'Ola';

    if (RegExp(r'^\d+$').hasMatch(cleanVPA)) return 'Individual';

    final parts = cleanVPA.split(RegExp(r'[.\-_]'));
    final firstOrNull = parts.firstWhere(
      (part) => part.length > 3 && !part.split('').every((c) => '0123456789'.contains(c)),
      orElse: () => '',
    );

    final matched = firstOrNull.isEmpty ? 'merchant' : firstOrNull;
    if (matched == 'merchant') return 'merchant';
    return matched.substring(0, 1).toUpperCase() + matched.substring(1);
  }
}
