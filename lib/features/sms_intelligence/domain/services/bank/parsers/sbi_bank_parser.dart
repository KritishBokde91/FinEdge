import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for State Bank of India (SBI) SMS messages.
///
/// Direct port of `parser-core/bank/SBIBankParser.kt`.
class SbiBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'State Bank of India';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('SBI') ||
        normalizedSender.contains('SBIINB') ||
        normalizedSender.contains('SBIUPI') ||
        normalizedSender.contains('SBICRD') ||
        normalizedSender.contains('ATMSBI') ||
        normalizedSender == 'SBIBK' ||
        normalizedSender == 'SBIBNK' ||
        normalizedSender.contains('SBI CARDS') ||
        RegExp(r'^[A-Z]{2}-SBIBK-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SBIBK-[TPG]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SBIBK$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-SBI$').hasMatch(normalizedSender);
  }

  bool _isCreditCardMessage(String sender, String message) {
    final upperSender = sender.toUpperCase();
    return upperSender.contains('SBICRD') ||
        upperSender.contains('SBI CARDS') ||
        message.toLowerCase().contains('credit card');
  }

  String? _extractCreditCardLast4(String message) {
    final patterns = [
      RegExp(r'ending\s+with\s+(\d{4})', caseSensitive: false),
      RegExp(r'ending\s+(\d{4})', caseSensitive: false),
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
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    final normalizedBody = normalizeUnicodeText(smsBody);

    final parsed = super.parse(normalizedBody, sender, timestamp);
    if (parsed == null) return null;

    if (_isCreditCardMessage(sender, normalizedBody)) {
      final cardLast4 = _extractCreditCardLast4(normalizedBody) ?? parsed.accountLast4;
      final creditLimit = extractAvailableLimit(normalizedBody) ?? parsed.creditLimit;

      final lowerBody = normalizedBody.toLowerCase();
      final transactionType = (() {
        if (lowerBody.contains('payment of') &&
            lowerBody.contains('credited to your sbi credit card')) {
          return TransactionType.income;
        } else if (lowerBody.contains('spent on') || lowerBody.contains('spent')) {
          return TransactionType.credit;
        }
        return TransactionType.credit;
      })();

      final merchant = (() {
        if (lowerBody.contains('via bbps')) {
          return 'BBPS Payment';
        }
        return _extractCreditCardMerchant(normalizedBody) ?? parsed.merchant;
      })();

      return parsed.copyWith(
        accountLast4: cardLast4,
        type: transactionType,
        merchant: merchant,
        creditLimit: creditLimit,
        isFromCard: true,
      );
    }

    return parsed;
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

  String? _extractCreditCardMerchant(String message) {
    final atPattern = RegExp(r'at\s+([A-Za-z0-9\s&._-]+?)\s+on\s+\d', caseSensitive: false);
    final match = atPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) {
        return merchant;
      }
    }
    return null;
  }

  @override
  double? extractAvailableLimit(String message) {
    final patterns = [
      RegExp(r'available\s+limit\s+is\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'Your\s+available\s+limit\s+is\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final limitStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(limitStr);
      }
    }

    return super.extractAvailableLimit(message);
  }

  @override
  double? extractAmount(String message) {
    final transactionNumberPattern = RegExp(
      r'transaction\s+number\s+\d+\s+for\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    var match = transactionNumberPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final paymentPattern = RegExp(r'payment\s+of\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false);
    match = paymentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final spentPattern = RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)\s+spent', caseSensitive: false);
    match = spentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final upiDebitPattern = RegExp(r'debited\s+by\s+(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false);
    match = upiDebitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final upiCreditPattern = RegExp(r'credited\s+by\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{1,2})?)', caseSensitive: false);
    match = upiCreditPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final debitPattern1 = RegExp(
      r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:has\s+been\s+)?debited',
      caseSensitive: false,
    );
    match = debitPattern1.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final debitPattern2 = RegExp(
      r'INR\s*(\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:has\s+been\s+)?debited',
      caseSensitive: false,
    );
    match = debitPattern2.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern1 = RegExp(
      r'Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:has\s+been\s+)?credited',
      caseSensitive: false,
    );
    match = creditPattern1.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern2 = RegExp(
      r'INR\s*(\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:has\s+been\s+)?credited',
      caseSensitive: false,
    );
    match = creditPattern2.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final withdrawPattern = RegExp(r'withdrawn\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = withdrawPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final transferPattern = RegExp(r'transferred\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = transferPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final upiPattern = RegExp(r'paid\s+to\s+[\w.-]+@[\w]+\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = upiPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final atmPattern = RegExp(r'ATM\s+withdrawal\s+of\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = atmPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final yonoCashPattern = RegExp(r'Yono\s+Cash\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = yonoCashPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;
    if (lowerMessage.contains('transferred')) return TransactionType.expense;
    if (lowerMessage.contains('paid to')) return TransactionType.expense;
    if (lowerMessage.contains('atm withdrawal')) return TransactionType.expense;
    if (lowerMessage.contains('by sbi debit card')) return TransactionType.expense;

    return super.extractTransactionType(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final doneAtPattern = RegExp(r'done\s+at\s+([^.\n]+?)(?:\s+on\s+|$)', caseSensitive: false);
    var match = doneAtPattern.firstMatch(message);
    if (match != null) {
      final location = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(location)) return location;
    }

    final trfPattern = RegExp(r'trf\s+to\s+([^.\n]+?)(?:\s+Ref|\s+ref|$)', caseSensitive: false);
    match = trfPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    final transferFromPattern = RegExp(r'transfer\s+from\s+([^.\n]+?)(?:\s+Ref|\s+ref|$)', caseSensitive: false);
    match = transferFromPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    final upiMerchantPattern = RegExp(r'paid\s+to\s+([\w.-]+)@[\w]+', caseSensitive: false);
    match = upiMerchantPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    final yonoAtmPattern = RegExp(r'w/d@SBI\s+ATM\s+([A-Z0-9]+)', caseSensitive: false);
    match = yonoAtmPattern.firstMatch(message);
    if (match != null) {
      return 'YONO Cash ATM - ${match.group(1)}';
    }

    final atmPattern = RegExp(r'ATM\s+(?:withdrawal\s+)?(?:at\s+)?([^.\n]+?)(?:\s+on|\s+Avl)', caseSensitive: false);
    match = atmPattern.firstMatch(message);
    if (match != null) {
      final location = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(location)) return 'ATM - $location';
    }

    final neftPattern = RegExp(r'(?:NEFT|IMPS|RTGS)[^:]*:\s*([^.\n]+?)(?:\s+Ref|\s+on|$)', caseSensitive: false);
    match = neftPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    return super.extractMerchant(message, sender);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    final debitCardPattern = RegExp(r'by\s+SBI\s+Debit\s+Card\s+([\w\-]+)', caseSensitive: false);
    var match = debitCardPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final pattern1 = RegExp(r'A/c\s+([X*\d]+)', caseSensitive: false);
    match = pattern1.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final pattern2 = RegExp(r'A/c\s+ending\s+(\d{4})', caseSensitive: false);
    match = pattern2.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final pattern3 = RegExp(r'a/c\s+no\.?\s+([X*\d]+)', caseSensitive: false);
    match = pattern3.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }

  @override
  double? extractBalance(String message) {
    final updatedBalancePattern = RegExp(
      r'Your\s+updated\s+available\s+balance\s+is\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)',
      caseSensitive: false,
    );
    var match = updatedBalancePattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final pattern1 = RegExp(r'Avl\s+Bal\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = pattern1.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final pattern2 = RegExp(r'Available\s+Balance:?\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = pattern2.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final pattern3 = RegExp(r'Bal:?\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    match = pattern3.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractBalance(message);
  }

  @override
  String? extractReference(String message) {
    final transactionNumberPattern = RegExp(r'transaction\s+number\s+([\w\-]+)', caseSensitive: false);
    var match = transactionNumberPattern.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final pattern1 = RegExp(r'Ref\s+No\.?\s*(\w+)', caseSensitive: false);
    match = pattern1.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final pattern2 = RegExp(r'Txn#\s*(\w+)', caseSensitive: false);
    match = pattern2.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    final pattern3 = RegExp(r'transaction\s+ID:?\s*(\w+)', caseSensitive: false);
    match = pattern3.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }

    return super.extractReference(message);
  }

  @override
  bool isTransactionMessage(String message) {
    final normalizedMessage = normalizeUnicodeText(message);
    final lowerMessage = normalizedMessage.toLowerCase();

    if (lowerMessage.contains('e-statement of sbi credit card')) return false;
    if (lowerMessage.contains('is due for')) return false;

    if (lowerMessage.contains('sbi card application') ||
        lowerMessage.contains('process your app.no') ||
        lowerMessage.contains('track your application status')) {
      return false;
    }

    if (isEMandateNotification(normalizedMessage) || isUPIMandateNotification(normalizedMessage)) {
      return false;
    }

    if (lowerMessage.contains('by sbi debit card')) return true;
    if (lowerMessage.contains('spent') && lowerMessage.contains('credit card')) return true;

    return super.isTransactionMessage(normalizedMessage);
  }

  bool isUPIMandateNotification(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('upi-mandate') ||
        lowerMessage.contains('upi mandate') ||
        (lowerMessage.contains('mandate') && lowerMessage.contains('created') && lowerMessage.contains('upi'));
  }

  SbiUPIMandateInfo? parseUPIMandateSubscription(String message) {
    if (!isUPIMandateNotification(message) && !isEMandateNotification(message)) {
      return null;
    }

    final amountPatterns = [
      RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    double? amount;
    for (final pattern in amountPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        amount = double.tryParse(amountStr);
        if (amount != null) break;
      }
    }

    if (amount == null) return null;

    var merchant = 'Unknown Subscription';
    final merchantPatterns = [
      RegExp(r'towards\s+([^.\n]+?)(?:\s+from|\s+A/c|\s+UMRN|\s+ID:|\s+Alert:|\s*\.|$)', caseSensitive: false),
      RegExp(r'for\s+([^.\n]+?)(?:\s+ID:|\s+Act:|\s*\.|$)', caseSensitive: false),
      RegExp(r'mandate\s+created\s+for\s+([^.\n]+?)(?:\s+UMN|\s+of|\s*\.|$)', caseSensitive: false),
    ];

    for (final pattern in merchantPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final m = cleanMerchantName(match.group(1)!.trim());
        if (isValidMerchantName(m)) {
          merchant = m;
          break;
        }
      }
    }

    final datePatterns = [
      RegExp(r'on\s+(\d{2}-\w{3}-\d{2,4})', caseSensitive: false),
      RegExp(r'date[:\s]+(\d{2}/\d{2}/\d{2,4})', caseSensitive: false),
      RegExp(r'(\d{2}-\d{2}-\d{4})', caseSensitive: false),
    ];

    String? nextDeductionDate;
    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        nextDeductionDate = match.group(1);
        break;
      }
    }

    final umnPattern = RegExp(r'UMN[:\s]+([^.\s]+)', caseSensitive: false);
    final umn = umnPattern.firstMatch(message)?.group(1);

    return SbiUPIMandateInfo(
      amount: amount,
      nextDeductionDate: nextDeductionDate,
      merchant: merchant,
      umn: umn,
    );
  }
}

class SbiUPIMandateInfo implements MandateInfo {
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

  const SbiUPIMandateInfo({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
  });
}
