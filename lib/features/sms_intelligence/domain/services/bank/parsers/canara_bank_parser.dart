import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Canara Bank SMS messages.
///
/// Direct port of `parser-core/bank/CanaraBankParser.kt`.
class CanaraBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Canara Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('CANBNK') ||
        normalizedSender.contains('CANARA');
  }

  @override
  double? extractAmount(String message) {
    final upiAmountPattern = RegExp(
      r'Rs\.?\s*([\d,]+(?:\.\d{2})?)\s+paid',
      caseSensitive: false,
    );
    var match = upiAmountPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final debitPattern = RegExp(
      r'INR\s+([\d,]+(?:\.\d{2})?)\s+has\s+been\s+DEBITED',
      caseSensitive: false,
    );
    match = debitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final rtgsSenderPattern = RegExp(
      r'by\s+Sender\s+([^,]+?)(?:,\s*IFSC|,\s*Sender\s+A/c|\s*$)',
      caseSensitive: false,
    );
    var match = rtgsSenderPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    final upiMerchantPattern = RegExp(
      r'\sto\s+([^,]+?)(?:,\s*UPI|\.|-Canara)',
      caseSensitive: false,
    );
    match = upiMerchantPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }

    if (message.toLowerCase().contains('debited')) {
      return 'Canara Bank Debit';
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final accountPattern = RegExp(
      r'(?:account|A/C)\s+([X*\d]+)',
      caseSensitive: false,
    );
    final match = accountPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final balancePattern = RegExp(
      r'(?:Total\s+)?Avail\.?bal\s+INR\s+([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final match = balancePattern.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    return super.extractBalance(message);
  }

  @override
  String? extractReference(String message) {
    final upiRefPattern = RegExp(
      r'UPI\s+Ref\s+(\d+)',
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

    if (lowerMessage.contains('failed due to')) {
      return false;
    }

    if (lowerMessage.contains('paid thru') ||
        lowerMessage.contains('has been debited') ||
        lowerMessage.contains('has been credited')) {
      return true;
    }

    return super.isTransactionMessage(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('redemption') && lowerMessage.contains('credited')) {
      return TransactionType.income;
    }

    return super.extractTransactionType(message);
  }
}
