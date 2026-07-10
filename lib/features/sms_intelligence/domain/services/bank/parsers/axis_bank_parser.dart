import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Axis Bank SMS messages.
///
/// Direct port of `parser-core/bank/AxisBankParser.kt`.
class AxisBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Axis Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('AXIS BANK') ||
        normalizedSender.contains('AXISBANK') ||
        normalizedSender.contains('AXISBK') ||
        normalizedSender.contains('AXISB') ||
        RegExp(r'^[A-Z]{2}-AXISBK-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-AXISBANK-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-AXIS-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-AXISBK$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-AXIS$').hasMatch(normalizedSender) ||
        normalizedSender == 'AXISBK' ||
        normalizedSender == 'AXISBANK' ||
        normalizedSender == 'AXIS';
  }

  @override
  double? extractAmount(String message) {
    final inrDebitPattern = RegExp(
      r'INR\s+([0-9,]+(?:\.\d{2})?)\s+debited',
      caseSensitive: false,
    );
    var match = inrDebitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final inrCreditPattern = RegExp(
      r'INR\s+([0-9,]+(?:\.\d{2})?)\s+credited',
      caseSensitive: false,
    );
    match = inrCreditPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final paymentPattern = RegExp(
      r'Payment\s+of\s+INR\s+([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = paymentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final lowerMessage = message.toLowerCase();

    // ATM withdrawal detection
    if (lowerMessage.contains('debited from a/c no.') &&
        lowerMessage.contains(' on axis bank')) {
      return 'ATM';
    }

    if ((lowerMessage.contains('atm') || lowerMessage.contains('cash withdrawal')) &&
        lowerMessage.contains('debited')) {
      return 'ATM';
    }

    // Debit card transaction pattern
    final debitCardPattern = RegExp(
      r'debited from A/c no\. [^\s]+ on ([^0-9]+?)(?:\d{2}-\d{2}-\d{4})',
      caseSensitive: false,
    );
    match = debitCardPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match!.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    // Credit card "Spent" transactions with merchant on separate line (with IST)
    final spentPatternWithIST = RegExp(
      r'Spent[\s\S]*?IST\s*\n\s*([^\n]+?)(?:\s*\n|\s*Avl Limit:|\s*Avl Lmt|\s*Not you?)',
      caseSensitive: false,
    );
    match = spentPatternWithIST.firstMatch(message);
    if (match != null) {
      var merchant = match!.group(1)!.trim();
      merchant = merchant.replaceAll(RegExp(r'\s+Limi$'), '');
      merchant = merchant.replaceAll(RegExp(r'\s+Pay$'), '');
      merchant = merchant.replaceAll(RegExp(r'\s+SUPE$'), '');
      merchant = cleanMerchantName(merchant);
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    // Alternative pattern without IST
    final spentPatternWithTime = RegExp(
      r'Spent[\s\S]*?\d{2}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\s*\n\s*([^\n]+?)(?:\s*\n|\s*Avl Limit:|\s*Avl Lmt|\s*Not you?)',
      caseSensitive: false,
    );
    match = spentPatternWithTime.firstMatch(message);
    if (match != null) {
      var merchant = match!.group(1)!.trim();
      merchant = merchant.replaceAll(RegExp(r'\s+Limi$'), '');
      merchant = merchant.replaceAll(RegExp(r'\s+Pay$'), '');
      merchant = merchant.replaceAll(RegExp(r'\s+SUPE$'), '');
      merchant = cleanMerchantName(merchant);
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    final upiMerchantPattern = RegExp(
      r'UPI/[^/]+/[^/]+/([^\n]+?)(?:\s*Not you|\s*$)',
      caseSensitive: false,
    );
    match = upiMerchantPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match!.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    final upiPersonPattern = RegExp(
      r'UPI/P2A/[^/]+/([^\n]+?)(?:\s*Not you|\s*$)',
      caseSensitive: false,
    );
    match = upiPersonPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match!.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    final infoPattern = RegExp(
      r'Info\s*[-–]\s*([^.\n]+?)(?:\.\s*Chk|\s*$)',
      caseSensitive: false,
    );
    match = infoPattern.firstMatch(message);
    if (match != null) {
      final info = match!.group(1)!.trim();
      if (info.toLowerCase().contains('salary')) {
        return 'Salary';
      } else {
        return cleanMerchantName(info);
      }
    }

    return super.extractMerchant(message, sender);
  }

  // Keep a local nullable RegExpMatch reference for convenience
  RegExpMatch? match;

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final acNoPattern = RegExp(
      r'A/c\s+no\.\s+([X*xX\d]+)',
      caseSensitive: false,
    );
    var match = acNoPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final cardNoPattern = RegExp(
      r'Card\s+no\.\s+([X*\d]+)',
      caseSensitive: false,
    );
    match = cardNoPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final creditCardPattern = RegExp(
      r'Credit\s+Card\s+([X*\d]+)',
      caseSensitive: false,
    );
    match = creditCardPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  String? extractReference(String message) {
    final upiRefPattern = RegExp(
      r'UPI/[^/]+/([0-9]+)',
      caseSensitive: false,
    );
    final match = upiRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return super.extractReference(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('payment') &&
        lowerMessage.contains('has been received') &&
        lowerMessage.contains('towards your axis bank')) {
      return false;
    }

    return super.isTransactionMessage(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('avl limit') || lowerMessage.contains('avl lmt')) {
      return TransactionType.credit;
    }

    if ((lowerMessage.contains('credit card') || lowerMessage.contains(' cc ')) &&
        (lowerMessage.contains('debited') || lowerMessage.contains('spent'))) {
      return TransactionType.credit;
    }

    return super.extractTransactionType(message);
  }

  @override
  double? extractAvailableLimit(String message) {
    final axisCreditLimitPatterns = [
      RegExp(r'Avl\s+Limit:?\s*INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Avl\s+Lmt\s+INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Available\s+limit:?\s*INR\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    for (final pattern in axisCreditLimitPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final limitStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(limitStr);
      }
    }

    return super.extractAvailableLimit(message);
  }
}
