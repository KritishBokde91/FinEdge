import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Bank of Baroda (BOB) SMS messages.
///
/// Direct port of `parser-core/bank/BankOfBarodaParser.kt`.
class BankOfBarodaParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Bank of Baroda';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('BOB') ||
        normalizedSender.contains('BARODA') ||
        normalizedSender.contains('BOBSMS') ||
        normalizedSender.contains('BOBTXN') ||
        normalizedSender.contains('BOBCRD') ||
        RegExp(r'^[A-Z]{2}-BOBSMS-[A-Z]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-BOBTXN-[A-Z]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-BOB-[A-Z]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-BOBCRD-[A-Z]$').hasMatch(normalizedSender) ||
        normalizedSender == 'BOB' ||
        normalizedSender == 'BANKOFBARODA';
  }

  @override
  double? extractAmount(String message) {
    final alertSpentPattern = RegExp(
      r'ALERT:\s*INR\s*([\d,]+(?:\.\d{2})?)\s+is\s+spent',
      caseSensitive: false,
    );
    var match = alertSpentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final transferPattern = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+transferred\s+from',
      caseSensitive: false,
    );
    match = transferPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final drPattern = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+Dr\.?\s+from',
      caseSensitive: false,
    );
    match = drPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern = RegExp(
      r'credited\s+with\s+INR\s+([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = creditPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern2 = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+Credited\s+to',
      caseSensitive: false,
    );
    match = creditPattern2.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final crPattern = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+.*?Cr\.?\s+to',
      caseSensitive: false,
    );
    match = crPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final cashDepositPattern = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+deposited\s+in\s+cash',
      caseSensitive: false,
    );
    match = cashDepositPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final transferToPattern = RegExp(
      r'transferred\s+from\s+A/c\s+[^\s]+\s+to:\s*([^.]+?)(?:\.|$)',
      caseSensitive: false,
    );
    var match = transferToPattern.firstMatch(message);
    if (match != null) {
      final merchantRaw = match.group(1)!.trim();
      final merchant = merchantRaw.split(RegExp(r'\s+Total\s+Bal', caseSensitive: false))[0].trim();
      if (isValidMerchantName(merchant)) {
        return cleanMerchantName(merchant);
      }
    }

    final upiPattern = RegExp(
      r'Cr\.?\s+to\s+([^\s]+@[^\s.]+)',
      caseSensitive: false,
    );
    match = upiPattern.firstMatch(message);
    if (match != null) {
      final vpa = match.group(1)!;
      final name = vpa.split('@').first;
      return name == 'redacted' ? 'UPI Payment' : cleanMerchantName(name);
    }

    final impsPattern = RegExp(
      r'IMPS/[\d]+\s+by\s+([^.]+?)(?:\s*\.|$)',
      caseSensitive: false,
    );
    match = impsPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('upi')) {
      if (lowerMessage.contains('credited')) {
        return 'UPI Credit';
      } else if (lowerMessage.contains('dr.')) {
        return 'UPI Payment';
      }
    }

    if (lowerMessage.contains('imps')) {
      return 'IMPS Transfer';
    }

    if (lowerMessage.contains('deposited in cash')) {
      return 'Cash Deposit';
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final bobCardPattern = RegExp(
      r'BOBCARD\s+ending\s+(\d{4})',
      caseSensitive: false,
    );
    var match = bobCardPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final acPattern = RegExp(
      r'A/[Cc]\s+([X.*\d]+)',
      caseSensitive: false,
    );
    match = acPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final avlBalPattern = RegExp(
      r'AvlBal:\s*Rs\.?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    var match = avlBalPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    final totalBalPattern = RegExp(
      r'Total\s+Bal:\s*Rs\.?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = totalBalPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    final avlAmtPattern = RegExp(
      r'Avlbl\s+Amt:\s*Rs\.?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = avlAmtPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    return super.extractBalance(message);
  }

  @override
  String? extractReference(String message) {
    final refPattern1 = RegExp(r'Ref:\s*(\d+)', caseSensitive: false);
    var match = refPattern1.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final upiRefPattern = RegExp(r'UPI\s+Ref\s+No\s+(\d+)', caseSensitive: false);
    match = upiRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final impsRefPattern = RegExp(r'IMPS/(\d+)', caseSensitive: false);
    match = impsRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return super.extractReference(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('spent on your bobcard') ||
        (lowerMessage.contains('bobcard') && lowerMessage.contains('spent')) ||
        (lowerMessage.contains('bobcard') && lowerMessage.contains('is spent'))) {
      return TransactionType.credit;
    }

    if (lowerMessage.contains('transferred from') ||
        lowerMessage.contains('dr.') ||
        lowerMessage.contains('debited')) {
      return TransactionType.expense;
    }

    if (lowerMessage.contains('cr.') ||
        lowerMessage.contains('credited') ||
        lowerMessage.contains('deposited')) {
      return TransactionType.income;
    }

    return super.extractTransactionType(message);
  }

  @override
  double? extractAvailableLimit(String message) {
    final creditLimitPattern = RegExp(
      r'Available\s+credit\s+limit\s+is\s+Rs\.?\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final match = creditLimitPattern.firstMatch(message);
    if (match != null) {
      final limitStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(limitStr);
    }

    return super.extractAvailableLimit(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('payment of') &&
        lowerMessage.contains('received for your bobcard')) {
      return false;
    }

    if (lowerMessage.contains('dr. from') ||
        lowerMessage.contains('cr. to') ||
        lowerMessage.contains('credited to a/c') ||
        lowerMessage.contains('credited with inr') ||
        lowerMessage.contains('deposited in cash') ||
        lowerMessage.contains('transferred from') ||
        lowerMessage.contains('is spent')) {
      return true;
    }

    return super.isTransactionMessage(message);
  }
}
