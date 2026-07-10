import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Juspay/Amazon Pay wallet transactions.
///
/// Direct port of `parser-core/bank/JuspayParser.kt`.
class JuspayParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Amazon Pay';

  @override
  String getCurrency() => 'INR';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('JUSPAY') ||
        normalizedSender.contains('APAY') ||
        normalizedSender == 'AMAZON PAY';
  }

  @override
  double? extractAmount(String message) {
    final debitPattern = RegExp(r'debited\s+for\s+INR\s+([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false);
    var match = debitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final paymentPattern = RegExp(r'Payment\s+of\s+Rs\s+([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false);
    match = paymentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final genericPattern = RegExp(r'Rs\s+([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false);
    match = genericPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final inrPattern = RegExp(r'INR\s+([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false);
    match = inrPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final merchantPattern = RegExp(
      r'successful\s+at\s+(.+?)(?:\.\s*Updated|\s*\.\s*Updated|\.(?:\s|$))',
      caseSensitive: false,
    );
    final match = merchantPattern.firstMatch(message);
    if (match != null) {
      return match.group(1)!.trim();
    }

    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('amazon')) return 'Amazon';
    if (lowerMessage.contains('flipkart')) return 'Flipkart';
    if (lowerMessage.contains('swiggy')) return 'Swiggy';
    if (lowerMessage.contains('zomato')) return 'Zomato';
    if (lowerMessage.contains('ola')) return 'Ola';
    if (lowerMessage.contains('uber')) return 'Uber';
    if (lowerMessage.contains('zepto')) return 'Zepto';
    if (lowerMessage.contains('blinkit')) return 'Blinkit';
    if (lowerMessage.contains('apay wallet') || lowerMessage.contains('wallet')) {
      return 'Amazon Pay Transaction';
    }

    return super.extractMerchant(message, sender) ?? 'Amazon Pay';
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('debited')) return TransactionType.expense;
    if (lowerMessage.contains('payment')) return TransactionType.expense;
    if (lowerMessage.contains('charged')) return TransactionType.expense;
    if (lowerMessage.contains('credited')) return TransactionType.credit;
    if (lowerMessage.contains('refunded')) return TransactionType.credit;
    if (lowerMessage.contains('received')) return TransactionType.credit;

    return null;
  }

  @override
  String? extractReference(String message) {
    final refPattern = RegExp(
      r'Transaction\s+Reference\s+Number\s+is\s+(\d{12})',
      caseSensitive: false,
    );
    var match = refPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final altRefPattern = RegExp(
      r'Reference\s+(?:Number|No)[:\s]+(\d{12})',
      caseSensitive: false,
    );
    match = altRefPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return super.extractReference(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    const transactionKeywords = [
      'debited for',
      'payment of rs',
      'using apay balance',
      'transaction reference number',
      'updated balance is',
    ];

    return transactionKeywords.any((kw) => lowerMessage.contains(kw)) ||
        super.isTransactionMessage(message);
  }
}
