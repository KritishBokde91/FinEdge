import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Indian Bank.
///
/// Direct port of `parser-core/bank/IndianBankParser.kt`.
class IndianBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Indian Bank';

  @override
  bool canHandle(String sender) {
    final normalized = sender.toUpperCase();
    return normalized.contains('INDIAN BANK') ||
        normalized.contains('INDIANBANK') ||
        normalized.contains('INDIANBK') ||
        RegExp(r'^[A-Z]{2}-INDBNK-S$').hasMatch(normalized) ||
        RegExp(r'^[A-Z]{2}-INDBNK-[TPG]$').hasMatch(normalized) ||
        RegExp(r'^[A-Z]{2}-INDBNK$').hasMatch(normalized) ||
        normalized == 'INDBNK' ||
        normalized == 'INDIAN';
  }

  @override
  double? extractAmount(String message) {
    final debitPattern = RegExp(r'debited\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    var match = debitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern = RegExp(r'credited\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = creditPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPatternReverse = RegExp(r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)\s+credited\s+to', caseSensitive: false);
    match = creditPatternReverse.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final withdrawnPattern = RegExp(r'withdrawn\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = withdrawnPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final upiPattern = RegExp(r'UPI\s+payment\s+of\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = upiPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final toPattern = RegExp(r'to\s+([^.\n]+?)(?:\.\s*UPI:|UPI:|$)', caseSensitive: false);
    var match = toPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    final fromPattern = RegExp(r'from\s+([^.\n]+?)(?:\.\s*UPI:|UPI:|$)', caseSensitive: false);
    match = fromPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    final vpaPattern = RegExp(r'VPA\s+([\w.-]+@[\w]+)', caseSensitive: false);
    match = vpaPattern.firstMatch(message);
    if (match != null) {
      final vpa = match.group(1)!;
      final merchantFromVpa = vpa.split('@').first;
      return cleanMerchantName(merchantFromVpa);
    }

    final atmPattern = RegExp(r'ATM\s+(?:withdrawal\s+)?at\s+([^.\n]+?)(?:\s+on|$)', caseSensitive: false);
    match = atmPattern.firstMatch(message);
    if (match != null) {
      final location = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(location)) return 'ATM - $location';
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final pattern1 = RegExp(r'A/c\s+([*X\d]+)', caseSensitive: false);
    var match = pattern1.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final pattern2 = RegExp(r'Account\s+([X*\d]+)', caseSensitive: false);
    match = pattern2.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final pattern3 = RegExp(r'A/c\s+ending\s+(\d{4})', caseSensitive: false);
    match = pattern3.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  String? extractReference(String message) {
    final upiRefPattern = RegExp(r'UPI:(\d+)', caseSensitive: false);
    var match = upiRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final upiRefNoPattern = RegExp(r'UPI\s+Ref\s+no\s+(\d+)', caseSensitive: false);
    match = upiRefNoPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final refNoPattern = RegExp(r'Ref\s+No\.?\s*(\w+)', caseSensitive: false);
    match = refNoPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final txnIdPattern = RegExp(r'Transaction\s+ID:?\s*(\w+)', caseSensitive: false);
    match = txnIdPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return super.extractReference(message);
  }

  @override
  double? extractBalance(String message) {
    final balPattern1 = RegExp(r'Bal[:\s-]+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    var match = balPattern1.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    final balPattern2 = RegExp(r'Available\s+Balance:?\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = balPattern2.firstMatch(message);
    if (match != null) {
      final balanceStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(balanceStr);
    }

    return super.extractBalance(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('debited')) return TransactionType.expense;
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;
    if (lowerMessage.contains('upi payment') && !lowerMessage.contains('received')) {
      return TransactionType.expense;
    }

    if (lowerMessage.contains('credited')) return TransactionType.income;
    if (lowerMessage.contains('deposited')) return TransactionType.income;
    if (lowerMessage.contains('received')) return TransactionType.income;

    return super.extractTransactionType(message);
  }

  bool isMandateNotification(String message) {
    return isEMandateNotification(message) || isFutureDebitNotification(message);
  }

  @override
  IndianMandateInfo? parseMandateSubscription(String message) {
    final baseInfo = super.parseMandateSubscription(message);
    if (baseInfo == null) return null;

    return IndianMandateInfo(
      amount: baseInfo.amount,
      nextDeductionDate: baseInfo.nextDeductionDate,
      merchant: baseInfo.merchant,
      umn: baseInfo.umn,
    );
  }
}

class IndianMandateInfo implements MandateInfo {
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

  const IndianMandateInfo({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
  });
}
