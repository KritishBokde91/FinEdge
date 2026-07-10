import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Punjab National Bank (PNB) SMS messages.
///
/// Direct port of `parser-core/bank/PNBBankParser.kt`.
class PnbBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Punjab National Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('PUNJAB NATIONAL BANK') ||
        normalizedSender.contains('PNBBNK') ||
        normalizedSender.contains('PUNBN') ||
        normalizedSender.contains('PNBSMS') ||
        RegExp(r'^[A-Z]{2}-PNBBNK-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-PNB-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-PNBBNK$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-PNB$').hasMatch(normalizedSender) ||
        normalizedSender == 'PNBBNK' ||
        normalizedSender == 'PNB';
  }

  @override
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    final normalizedBody = normalizeUnicodeText(smsBody);
    return super.parse(normalizedBody, sender, timestamp);
  }

  String normalizeUnicodeText(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune >= 0x1D5D4 && rune <= 0x1D5ED) {
        buffer.writeCharCode(rune - 0x1D5D4 + 0x41);
      } else if (rune >= 0x1D5EE && rune <= 0x1D607) {
        buffer.writeCharCode(rune - 0x1D5EE + 0x61);
      } else if (rune >= 0x1D5A0 && rune <= 0x1D5B9) {
        buffer.writeCharCode(rune - 0x1D5A0 + 0x41);
      } else if (rune >= 0x1D5BA && rune <= 0x1D5D3) {
        buffer.writeCharCode(rune - 0x1D5BA + 0x61);
      } else if (rune >= 0x1D400 && rune <= 0x1D419) {
        buffer.writeCharCode(rune - 0x1D400 + 0x41);
      } else if (rune >= 0x1D41A && rune <= 0x1D433) {
        buffer.writeCharCode(rune - 0x1D41A + 0x61);
      } else if (rune >= 0x1D434 && rune <= 0x1D44D) {
        buffer.writeCharCode(rune - 0x1D434 + 0x41);
      } else if (rune >= 0x1D44E && rune <= 0x1D467) {
        buffer.writeCharCode(rune - 0x1D44E + 0x61);
      } else if (rune >= 0x1D468 && rune <= 0x1D481) {
        buffer.writeCharCode(rune - 0x1D468 + 0x41);
      } else if (rune >= 0x1D482 && rune <= 0x1D49B) {
        buffer.writeCharCode(rune - 0x1D482 + 0x61);
      } else if (rune >= 0x1D7CE && rune <= 0x1D7D7) {
        buffer.writeCharCode(rune - 0x1D7CE + 0x30);
      } else if (rune >= 0x1D7D8 && rune <= 0x1D7E1) {
        buffer.writeCharCode(rune - 0x1D7D8 + 0x30);
      } else if (rune >= 0x1D7E2 && rune <= 0x1D7EB) {
        buffer.writeCharCode(rune - 0x1D7E2 + 0x30);
      } else if (rune >= 0x1D7EC && rune <= 0x1D7F5) {
        buffer.writeCharCode(rune - 0x1D7EC + 0x30);
      } else if (rune >= 0x1D7F6 && rune <= 0x1D7FF) {
        buffer.writeCharCode(rune - 0x1D7F6 + 0x30);
      } else if (rune < 128) {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  @override
  double? extractAmount(String message) {
    final debitedForPattern = RegExp(
      r'debited\s+for\s+(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    var match = debitedForPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final initialDebitPattern = RegExp(
      r'initial\s+amount\s+of\s+(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)\s+has\s+been\s+debited',
      caseSensitive: false,
    );
    match = initialDebitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final debitPattern = RegExp(
      r'debited\s+(?:with\s+)?(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = debitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern = RegExp(
      r'(?:(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)\s+(?:has\s+been\s+)?credited|credited\s+(?:with\s+)?(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?))',
      caseSensitive: false,
    );
    match = creditPattern.firstMatch(message);
    if (match != null) {
      final amountStr = (match.group(1) != null && match.group(1)!.isNotEmpty
              ? match.group(1)
              : match.group(2))!
          .replaceAll(',', '');
      return double.tryParse(amountStr);
    }

    return super.extractAmount(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (isUPIMandateNotification(message)) {
      return null;
    }

    if (lowerMessage.contains('auto pay facility') && lowerMessage.contains('debited')) {
      return TransactionType.expense;
    }

    return super.extractTransactionType(message);
  }

  bool isUPIMandateNotification(String message) {
    final lowerMessage = message.toLowerCase();
    return (lowerMessage.contains('upi-mandate') || lowerMessage.contains('upi mandate')) &&
        lowerMessage.contains('successfully created');
  }

  PnbUPIMandateInfo? parseUPIMandateSubscription(String message) {
    if (!isUPIMandateNotification(message)) {
      return null;
    }

    final amountPattern = RegExp(
      r'for\s+(?:Rs\.?|INR)\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final amtMatch = amountPattern.firstMatch(message);
    double? amount;
    if (amtMatch != null) {
      amount = double.tryParse(amtMatch.group(1)!.replaceAll(',', ''));
    }
    amount ??= super.parseMandateSubscription(message)?.amount;
    if (amount == null) return null;

    final merchantPattern = RegExp(
      r'towards\s+(.+?)\s+for\s+(?:Rs\.?|INR)',
      caseSensitive: false,
    );
    final merchantMatch = merchantPattern.firstMatch(message);
    String? merchant;
    if (merchantMatch != null) {
      final m = cleanMerchantName(merchantMatch.group(1)!.trim());
      if (isValidMerchantName(m)) {
        merchant = m;
      }
    }
    merchant ??= super.parseMandateSubscription(message)?.merchant;
    if (merchant == null) return null;

    final umnPattern = RegExp(r'UMN:?\s*([^.\s]+)', caseSensitive: false);
    final umn = umnPattern.firstMatch(message)?.group(1);

    return PnbUPIMandateInfo(
      amount: amount,
      nextDeductionDate: null,
      merchant: merchant,
      umn: umn,
    );
  }

  @override
  String? extractMerchant(String message, String sender) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('imps')) {
      return 'IMPS Transfer';
    }

    final fromMerchantPattern = RegExp(
      r'auto\s+pay.*?activated.*?from\s+([^.]+?)(?:\s+An\s+initial|\.|$)',
      caseSensitive: false,
    );
    var match = fromMerchantPattern.firstMatch(message);
    if (match != null) {
      return match.group(1)!.trim();
    }

    final towardsPattern = RegExp(
      r'UPI-Mandate.*towards\s+(.+?)\s+for',
      caseSensitive: false,
    );
    match = towardsPattern.firstMatch(message);
    if (match != null) {
      return match.group(1)!.trim();
    }

    final cardPattern = RegExp(r'thru\s+card\s+([X\*]+\d{4})', caseSensitive: false);
    match = cardPattern.firstMatch(message);
    if (match != null) {
      return 'Card ${match.group(1)}';
    }

    if (lowerMessage.contains('pnb atm')) {
      return 'PNB ATM Withdrawal';
    }

    if (lowerMessage.contains('neft')) {
      return 'NEFT Transfer';
    }

    if (lowerMessage.contains('upi')) {
      return 'UPI Transaction';
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final acNoPattern = RegExp(
      r'(?:a/c\s+no|A/c)\s+[X*]+(\d{2,4})',
      caseSensitive: false,
    );
    var match = acNoPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final acPattern = RegExp(
      r'(?:A/c(?:\s*No\.)?|Ac|Card)\s*(?:[X\*]+)?(\d{4,16})',
      caseSensitive: false,
    );
    match = acPattern.firstMatch(message);
    if (match != null) {
      final digits = match.group(1)!;
      return digits.substring(digits.length - 4);
    }

    return super.extractAccountLast4(message);
  }

  @override
  String? extractReference(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('imps')) {
      final impsRefPattern = RegExp(
        r'IMPS\s+\w*\s*Ref\s*(?:no\.?\s*)?(\d{6,})',
        caseSensitive: false,
      );
      var match = impsRefPattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }

      final impsFallback = RegExp(
        r'IMPS[^0-9]*(\d{12,})',
        caseSensitive: false,
      );
      match = impsFallback.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }
    }

    final neftRefPattern = RegExp(
      r'ref\s+no\.\s+([A-Z0-9]+)',
      caseSensitive: false,
    );
    var match = neftRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final upiRefIdPattern = RegExp(
      r'UPI\s+Ref\s+ID:?\s*(\d+)',
      caseSensitive: false,
    );
    match = upiRefIdPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final upiRefPattern = RegExp(
      r'UPI:\s*([0-9]+)',
      caseSensitive: false,
    );
    match = upiRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final baseRef = super.extractReference(message);
    if (baseRef != null && baseRef.toUpperCase() == 'PNB') {
      return null;
    }
    return baseRef;
  }

  @override
  double? extractBalance(String message) {
    final balPattern = RegExp(
      r'(?:Aval\s+Bal|Avl\s+Bal|Bal)\s*(?:INR\s*|Rs\.?\s*)?([0-9,]+(?:\.\d{2})?)(?:\s+(?:CR|DR))?',
      caseSensitive: false,
    );
    var match = balPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    final simpleBalPattern = RegExp(
      r'Bal\s*([0-9,]+(?:\.\d{2})?)\s+(?:CR|DR)',
      caseSensitive: false,
    );
    match = simpleBalPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    return super.extractBalance(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (isUPIMandateNotification(message)) {
      return false;
    }

    if (lowerMessage.contains('auto pay facility') && lowerMessage.contains('debited')) {
      return true;
    }

    if (lowerMessage.contains('register for e-statement')) {
      return true;
    }

    if (lowerMessage.contains('imps') && lowerMessage.contains('debited')) {
      return true;
    }

    return super.isTransactionMessage(message);
  }
}

class PnbUPIMandateInfo implements MandateInfo {
  @override
  final double amount;
  @override
  final String? nextDeductionDate;
  @override
  final String merchant;
  @override
  final String? umn;
  @override
  final String dateFormat = 'dd-MMM-yy';

  const PnbUPIMandateInfo({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
  });
}
