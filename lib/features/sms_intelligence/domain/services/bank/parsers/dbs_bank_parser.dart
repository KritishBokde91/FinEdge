import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for DBS Bank (Development Bank of Singapore) SMS messages.
///
/// Direct port of `parser-core/bank/DBSBankParser.kt`.
class DbsBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'DBS Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('DBSBNK') ||
        normalizedSender.contains('DBS') ||
        normalizedSender == 'DBSBANK' ||
        RegExp(r'^[A-Z]{2}-DBSBNK-[ST]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-DBS-[ST]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-DBSBANK-[ST]$').hasMatch(normalizedSender);
  }

  @override
  double? extractAmount(String message) {
    final patterns = [
      RegExp(r'(?:debited|credited)\s+with\s+INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)\s+(?:debited|credited)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(amountStr);
      }
    }

    return super.extractAmount(message);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final patterns = [
      RegExp(r'account\s+no\s+\*+(\d{4})', caseSensitive: false),
      RegExp(r'a/c\s+\*+(\d{4})', caseSensitive: false),
      RegExp(r'account\s+\*+(\d{4})', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final patterns = [
      RegExp(r'Current\s+Balance\s+is\s+INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Balance[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Avl\s+Bal[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final balanceStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(balanceStr);
      }
    }

    return super.extractBalance(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('debited')) return TransactionType.expense;
    if (lowerMessage.contains('credited')) return TransactionType.income;
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;
    if (lowerMessage.contains('deposited')) return TransactionType.income;

    return super.extractTransactionType(message);
  }
}
