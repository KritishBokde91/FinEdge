import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Saraswat Co-operative Bank.
///
/// Direct port of `parser-core/bank/SaraswatBankParser.kt`.
class SaraswatBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Saraswat Co-operative Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();

    const saraswatSenders = {
      'SARBNK',
      'SARASWAT',
      'SARASWATBANK',
    };

    if (saraswatSenders.contains(normalizedSender)) return true;

    return RegExp(r'^[A-Z]{2}-SARBNK-[ST]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SARASWAT-[ST]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SARBNK$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SARASWAT$').hasMatch(normalizedSender);
  }

  @override
  double? extractAmount(String message) {
    final inrPattern = RegExp(r'INR\s+(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    var match = inrPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final rsPattern = RegExp(r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = rsPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('is credited')) return TransactionType.income;
    if (lowerMessage.contains('credited with')) return TransactionType.income;
    if (lowerMessage.contains('is debited')) return TransactionType.expense;
    if (lowerMessage.contains('debited with')) return TransactionType.expense;
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;

    return super.extractTransactionType(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final towardsPattern = RegExp(
      r'towards\s+(.+?)(?:\.\s*Current|\s*Current|$)',
      caseSensitive: false,
    );
    var match = towardsPattern.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      final cleanedMerchant = merchant
          .replaceAll(RegExp(r'^ACH\s+Credit:\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'^ACH\s+Debit:\s*', caseSensitive: false), '')
          .trim();
      if (isValidMerchantName(cleanedMerchant)) {
        return cleanMerchantName(cleanedMerchant);
      }
    }

    final forPattern = RegExp(
      r'for\s+([A-Z.]+?)(?:\.\s+Current|\s+Current|$)',
      caseSensitive: false,
    );
    match = forPattern.firstMatch(message);
    if (match != null) {
      var merchant = match.group(1)!.trim();
      if (merchant.endsWith('.')) {
        merchant = merchant.substring(0, merchant.length - 1);
      }
      switch (merchant.toUpperCase()) {
        case 'S.I':
        case 'SI':
          return 'Standing Instruction';
        case 'NEFT':
          return 'NEFT Transfer';
        case 'RTGS':
          return 'RTGS Transfer';
        case 'IMPS':
          return 'IMPS Transfer';
        default:
          return merchant;
      }
    }

    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('atm') || lowerMessage.contains('withdrawn')) {
      return 'ATM Withdrawal';
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final accountNoPattern = RegExp(
      r'A/c\s+no\.\s+(?:ending\s+with\s+)?(\d{4,6})',
      caseSensitive: false,
    );
    var match = accountNoPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final endingWithPattern = RegExp(
      r'account\s+no\.\s+ending\s+with\s+(\d{4,6})',
      caseSensitive: false,
    );
    match = endingWithPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final pattern3 = RegExp(r'A/c\s+([*\d]+)', caseSensitive: false);
    match = pattern3.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final currentBalPattern = RegExp(
      r'Current\s+Bal\s+is\s+INR\s+(\d+(?:,\d{3})*(?:\.\d{2})?)\s*(?:CR|DR)?',
      caseSensitive: false,
    );
    var match = currentBalPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    final balPattern = RegExp(
      r'Bal[:\s]+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)',
      caseSensitive: false,
    );
    match = balPattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    return super.extractBalance(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('otp') ||
        lowerMessage.contains('one time password') ||
        lowerMessage.contains('verification code')) {
      return false;
    }

    const saraswatTransactionKeywords = [
      'is credited with',
      'is debited with',
      'credited with inr',
      'debited with inr',
      'current bal is',
    ];

    if (saraswatTransactionKeywords.any((kw) => lowerMessage.contains(kw))) {
      return true;
    }

    return super.isTransactionMessage(message);
  }
}
