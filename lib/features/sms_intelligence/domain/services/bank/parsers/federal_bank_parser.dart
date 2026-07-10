import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for Federal Bank SMS messages.
///
/// Direct port of `parser-core/bank/FederalBankParser.kt`.
class FederalBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'Federal Bank';

  @override
  bool canHandle(String sender) {
    final normalizedSender = sender.toUpperCase();
    return normalizedSender.contains('FEDBNK') ||
        normalizedSender.contains('FEDERAL') ||
        normalizedSender.contains('FEDFIB') ||
        normalizedSender.contains('FEDSCP') ||
        RegExp(r'^[A-Z]{2}-FEDBNK-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-FEDSCP-S$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-FedFiB-[A-Z]$', caseSensitive: false).hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-FEDBNK-[TPG]$').hasMatch(normalizedSender) ||
        RegExp(r'^[A-Z]{2}-FEDBNK$').hasMatch(normalizedSender);
  }

  @override
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    if (_isBalanceInquiryMessage(smsBody)) {
      return _parseBalanceInquiry(smsBody, sender, timestamp);
    }
    return super.parse(smsBody, sender, timestamp);
  }

  bool _isBalanceInquiryMessage(String message) {
    return message.toLowerCase().contains('your available balance for a/c');
  }

  ParsedTransaction? _parseBalanceInquiry(String message, String sender, int timestamp) {
    final balancePattern = RegExp(
      r'([A-Z]{2,3}\d{4})\s+is\s+INR\s+([0-9,]+(?:\.\d{1,2})?)(?=[,.]|\s+\.)',
      caseSensitive: false,
    );

    final match = balancePattern.firstMatch(message);
    if (match == null) return null;

    final accountNumber = match.group(1)!;
    final balanceStr = match.group(2)!.replaceAll(',', '');

    final balanceAreaPattern = RegExp(
      r'([A-Z]{2,3}\d{4})\s+is\s+INR\s+[0-9,x.]+',
      caseSensitive: false,
    );
    final balanceAreaMatch = balanceAreaPattern.firstMatch(message);
    final balanceArea = balanceAreaMatch?.group(0) ?? '';
    if (balanceArea.toLowerCase().contains('x')) {
      return null;
    }

    final balance = double.tryParse(balanceStr);
    if (balance == null) return null;

    final acLast4 = accountNumber.substring(accountNumber.length - 4);

    return ParsedTransaction(
      amount: 0.0,
      type: TransactionType.balanceUpdate,
      merchant: 'Balance Inquiry',
      reference: null,
      accountLast4: acLast4,
      balance: balance,
      smsBody: message,
      sender: sender,
      timestamp: timestamp,
      bankName: getBankName(),
      isFromCard: false,
      currency: 'INR',
    );
  }

  bool detectIsCreditCard(String message) {
    return message.toLowerCase().contains('credit card');
  }

  @override
  bool detectIsCard(String message) {
    final lowerMessage = message.toLowerCase();

    if (detectIsCreditCard(message)) return true;
    if (lowerMessage.contains('debit card')) return true;
    if (lowerMessage.contains('card xx**')) return true;
    if (lowerMessage.contains('card ending with')) return true;

    if (RegExp(r'.*inr\s+[\d,]+(?:\.\d{2})?\s+spent.*').hasMatch(lowerMessage)) return true;

    if (lowerMessage.contains(' spent ') &&
        lowerMessage.contains(' at ') &&
        lowerMessage.contains(' on ')) {
      return true;
    }

    if ((lowerMessage.contains('e-mandate') || lowerMessage.contains('payment of')) &&
        (lowerMessage.contains('federal bank debit card') ||
            lowerMessage.contains('federal bank credit card'))) {
      return true;
    }

    if (lowerMessage.contains('via upi')) return false;
    if (lowerMessage.contains('to vpa')) return false;
    if (lowerMessage.contains('atm')) return false;
    if (lowerMessage.contains('withdrawn') && !lowerMessage.contains('card')) return false;
    if (lowerMessage.contains('via imps')) return false;
    if (lowerMessage.contains('via neft')) return false;
    if (lowerMessage.contains('via rtgs')) return false;

    return false;
  }

  @override
  double? extractAmount(String message) {
    final rupeeSymbolPattern = RegExp(r'₹\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false);
    var match = rupeeSymbolPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final inrSpentPattern = RegExp(r'INR\s+([0-9,]+(?:\.\d{2})?)\s+spent', caseSensitive: false);
    match = inrSpentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final receivedPattern = RegExp(r"you've received INR\s+([0-9,]+(?:\.\d{2})?)", caseSensitive: false);
    match = receivedPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final debitPattern = RegExp(r'Rs\s+([0-9,]+(?:\.\d{2})?)\s+debited', caseSensitive: false);
    match = debitPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final sentPattern = RegExp(r'Rs\s+([0-9,]+(?:\.\d{2})?)\s+sent', caseSensitive: false);
    match = sentPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final creditPattern = RegExp(r'Rs\s+([0-9,]+(?:\.\d{2})?)\s+credited', caseSensitive: false);
    match = creditPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final hasReceivedPattern = RegExp(r'has\s+received\s+Rs\s+([0-9,]+(?:\.\d{2})?)\s+from', caseSensitive: false);
    match = hasReceivedPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    final withdrawnPattern = RegExp(r'withdrawn\s+Rs\s+([0-9,]+(?:\.\d{2})?)', caseSensitive: false);
    match = withdrawnPattern.firstMatch(message);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    return super.extractAmount(message);
  }

  @override
  String? extractMerchant(String message, String sender) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('withdrawn')) {
      return 'Cash Withdrawal';
    }

    final hasReceivedPattern = RegExp(r'^([A-Z][A-Za-z0-9\s]+?)\s+has\s+received\s+Rs', caseSensitive: false);
    var match = hasReceivedPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    if (lowerMessage.contains('credited to your a/c') && lowerMessage.contains('via imps')) {
      return 'IMPS Credit';
    }

    if (detectIsCard(message)) {
      if (lowerMessage.contains(' at ')) {
        final scapiaPattern = RegExp(r'at\s+([^.\n]+?)\s+on\s+your', caseSensitive: false);
        match = scapiaPattern.firstMatch(message);
        if (match != null) {
          final merchant = cleanMerchantName(match.group(1)!.trim());
          if (isValidMerchantName(merchant)) {
            final cleanedMerchant = merchant
                .replaceAll(RegExp(r'\s+(limited|ltd|pvt\s+ltd|private\s+limited)$', caseSensitive: false), '')
                .trim();
            return cleanedMerchant.isEmpty ? merchant : cleanedMerchant;
          }
        }

        final creditCardPattern = RegExp(r'at\s+([^.\n]+?)\s+on\s+\d', caseSensitive: false);
        match = creditCardPattern.firstMatch(message);
        if (match != null) {
          final merchant = cleanMerchantName(match.group(1)!.trim());
          if (isValidMerchantName(merchant)) {
            final cleanedMerchant = merchant
                .replaceAll(RegExp(r'\s+(limited|ltd|pvt\s+ltd|private\s+limited)$', caseSensitive: false), '')
                .trim();
            return cleanedMerchant.isEmpty ? merchant : cleanedMerchant;
          }
        }
      }
    }

    if (lowerMessage.contains('e-mandate') || lowerMessage.contains('payment of')) {
      final emandatePattern = RegExp(
        r'payment of\s+[^.]+?\s+for\s+([^.\n]+?)\s+via\s+e-mandate',
        caseSensitive: false,
      );
      match = emandatePattern.firstMatch(message);
      if (match != null) {
        final merchant = cleanMerchantName(match.group(1)!.trim());
        if (isValidMerchantName(merchant)) return merchant;
      }

      final emandateDeclinedPattern = RegExp(
        r'payment via e-mandate\s+declined\s+for\s+ID:\s*[^.]+?\s+on\s+Federal Bank\s+Debit Card\s+\d+',
        caseSensitive: false,
      );
      if (emandateDeclinedPattern.hasMatch(message)) {
        return 'E-Mandate Declined';
      }
    }

    if (lowerMessage.contains('vpa')) {
      final vpaPattern = RegExp(r'to\s+VPA\s+([^\s]+?)(?:\.\s*Ref\s+No|\s*Ref\s+No|$)', caseSensitive: false);
      match = vpaPattern.firstMatch(message);
      if (match != null) {
        return parseUPIMerchant(match.group(1)!.trim());
      }
    }

    final toPattern = RegExp(r'to\s+([^.\n]+?)(?:\.\s*Ref|Ref\s+No|$)', caseSensitive: false);
    match = toPattern.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      if (!merchant.toLowerCase().contains('vpa')) {
        final cleaned = cleanMerchantName(merchant);
        if (isValidMerchantName(cleaned)) return cleaned;
      }
    }

    if (lowerMessage.contains("you've received")) {
      final sentByPattern = RegExp(r'It was sent by\s+([^.\n]+?)(?:\s+on|$)', caseSensitive: false);
      match = sentByPattern.firstMatch(message);
      if (match != null) {
        final senderStr = match.group(1)!.trim();
        if (RegExp(r'^0+$').hasMatch(senderStr) || senderStr.length <= 4) {
          return 'Bank Transfer';
        }
        final merchant = cleanMerchantName(senderStr);
        if (isValidMerchantName(merchant)) return merchant;
      }
    }

    final fromPattern = RegExp(r'from\s+([^.\n]+?)(?:\.\s*|$)', caseSensitive: false);
    match = fromPattern.firstMatch(message);
    if (match != null) {
      final merchant = cleanMerchantName(match.group(1)!.trim());
      if (isValidMerchantName(merchant)) return merchant;
    }

    if (lowerMessage.contains('cash deposit') ||
        lowerMessage.contains('deposited') ||
        lowerMessage.contains('cdm') ||
        lowerMessage.contains('cash credited')) {
      return 'Cash Deposit';
    }

    return super.extractMerchant(message, sender);
  }

  String parseUPIMerchant(String vpa) {
    final cleanVPA = vpa.split('@').first.toLowerCase();

    if (cleanVPA.contains('indigo')) return 'Indigo';
    if (cleanVPA.contains('spicejet')) return 'SpiceJet';
    if (cleanVPA.contains('airasia')) return 'AirAsia';
    if (cleanVPA.contains('vistara')) return 'Vistara';
    if (cleanVPA.contains('airindia')) return 'Air India';

    if (cleanVPA.contains('uber')) return 'Uber';
    if (cleanVPA.contains('ola')) return 'Ola';
    if (cleanVPA.contains('rapido')) return 'Rapido';

    if (cleanVPA.contains('amazon')) return 'Amazon';
    if (cleanVPA.contains('flipkart')) return 'Flipkart';
    if (cleanVPA.contains('myntra')) return 'Myntra';
    if (cleanVPA.contains('meesho')) return 'Meesho';

    if (cleanVPA.contains('paytm')) return 'Paytm';
    if (cleanVPA.contains('bharatpe')) return 'BharatPe';
    if (cleanVPA.contains('phonepe')) return 'PhonePe';
    if (cleanVPA.contains('googlepay') || cleanVPA.contains('gpay')) return 'Google Pay';

    if (cleanVPA.contains('swiggy')) return 'Swiggy';
    if (cleanVPA.contains('zomato')) return 'Zomato';

    if (cleanVPA.contains('netflix')) return 'Netflix';
    if (cleanVPA.contains('spotify')) return 'Spotify';
    if (cleanVPA.contains('hotstar') || cleanVPA.contains('disney')) return 'Disney+ Hotstar';
    if (cleanVPA.contains('prime')) return 'Amazon Prime';
    if (cleanVPA.contains('pvr') || cleanVPA.contains('inox')) return 'PVR Inox';
    if (cleanVPA.contains('bookmyshow') || cleanVPA.contains('bms')) return 'BookMyShow';

    if (cleanVPA.contains('jio')) return 'Jio';
    if (cleanVPA.contains('airtel')) return 'Airtel';
    if (cleanVPA.contains('vodafone') || cleanVPA.contains('vi')) return 'Vi';
    if (cleanVPA.contains('bsnl')) return 'BSNL';

    if (cleanVPA.contains('irctc')) return 'IRCTC';
    if (cleanVPA.contains('redbus')) return 'RedBus';
    if (cleanVPA.contains('makemytrip') || cleanVPA.contains('mmt')) return 'MakeMyTrip';
    if (cleanVPA.contains('goibibo')) return 'Goibibo';
    if (cleanVPA.contains('oyo')) return 'OYO';
    if (cleanVPA.contains('airbnb')) return 'Airbnb';

    if (cleanVPA.contains('razorpay') || cleanVPA.contains('razorp') || cleanVPA.contains('rzp')) {
      if (cleanVPA.contains('pvr')) return 'PVR';
      if (cleanVPA.contains('inox')) return 'PVR Inox';
      if (cleanVPA.contains('swiggy')) return 'Swiggy';
      if (cleanVPA.contains('zomato')) return 'Zomato';
      return 'Online Payment';
    }

    if (cleanVPA.contains('payu') || cleanVPA.contains('billdesk') || cleanVPA.contains('ccavenue')) {
      return 'Online Payment';
    }

    if (RegExp(r'^\d+$').hasMatch(cleanVPA)) {
      return 'Individual';
    }

    return vpa.trim();
  }

  @override
  bool isTransactionMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('otp') ||
        lowerMessage.contains('one time password') ||
        lowerMessage.contains('verification code')) {
      return false;
    }

    if (isMandateCreationNotification(message) || isDeclinedMandatePayment(message)) {
      return false;
    }

    if (_isOutgoingHasReceivedPattern(message) && !isInvestmentTransaction(lowerMessage)) {
      return false;
    }

    const federalKeywords = [
      'sent via upi',
      'debited via upi',
      'credited',
      'withdrawn',
      'received',
      'transferred',
      'spent on your credit card',
      'credit card was successful',
      'payment of',
      'payment via e-mandate',
    ];

    if (federalKeywords.any((kw) => lowerMessage.contains(kw))) {
      return true;
    }

    return super.isTransactionMessage(message);
  }

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    if (detectIsCard(message)) {
      final endingWithPattern = RegExp(
        r'(?:credit|debit)\s+card\s+ending\s+with\s+(\d{4})',
        caseSensitive: false,
      );
      var match = endingWithPattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }

      final cardPattern = RegExp(
        r'card\s+XX\*\*?(\d{4})',
        caseSensitive: false,
      );
      match = cardPattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }

      final emandateCardPattern = RegExp(
        r'(?:Federal\s+Bank\s+)?(?:Debit|Credit)\s+Card\s+(\d{4})',
        caseSensitive: false,
      );
      match = emandateCardPattern.firstMatch(message);
      if (match != null) {
        return match.group(1);
      }
    }

    final acPattern = RegExp(
      r'A/c\s+([X*\d]+)',
      caseSensitive: false,
    );
    var match = acPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    final accountPattern = RegExp(
      r'Account\s+([X*\d]+)',
      caseSensitive: false,
    );
    match = accountPattern.firstMatch(message);
    if (match != null) {
      return extractLast4Digits(match.group(1)!);
    }

    return null;
  }



  @override
  TransactionType? extractTransactionType(String message) {
    final lowerMessage = message.toLowerCase();

    if (_isOutgoingHasReceivedPattern(message)) {
      if (isInvestmentTransaction(lowerMessage)) {
        return TransactionType.investment;
      } else {
        return TransactionType.expense;
      }
    }

    if (lowerMessage.contains('received your payment') && lowerMessage.contains('credit card')) {
      return TransactionType.transfer;
    }

    if (detectIsCreditCard(message) &&
        (lowerMessage.contains('spent') ||
            lowerMessage.contains('was successful') ||
            lowerMessage.contains('txn of'))) {
      return TransactionType.credit;
    }

    if ((lowerMessage.contains('e-mandate') || lowerMessage.contains('payment of')) &&
        lowerMessage.contains('processed successfully')) {
      return TransactionType.expense;
    }

    if (lowerMessage.contains('sent via upi')) return TransactionType.expense;
    if (lowerMessage.contains('debited')) return TransactionType.expense;
    if (lowerMessage.contains('withdrawn')) return TransactionType.expense;
    if (lowerMessage.contains('spent') && !detectIsCreditCard(message)) return TransactionType.expense;
    if (lowerMessage.contains('paid')) return TransactionType.expense;

    if (lowerMessage.contains('credited')) return TransactionType.income;
    if (lowerMessage.contains('received')) return TransactionType.income;
    if (lowerMessage.contains('deposited')) return TransactionType.income;
    if (lowerMessage.contains('refund')) return TransactionType.income;

    return super.extractTransactionType(message);
  }

  bool _isOutgoingHasReceivedPattern(String message) {
    final pattern = RegExp(
      r'has\s+received\s+Rs\s+[\d,.]+\s+from\s+your\s+A/c',
      caseSensitive: false,
    );
    return pattern.hasMatch(message);
  }

  bool isMandateCreationNotification(String message) {
    final lowerMessage = message.toLowerCase();

    return (lowerMessage.contains('mandate') || lowerMessage.contains('e-mandate')) &&
        (lowerMessage.contains('successfully created a mandate') ||
            lowerMessage.contains('you have successfully created') ||
            lowerMessage.contains('successfully created') ||
            lowerMessage.contains('has been initiated') ||
            lowerMessage.contains('registration has been initiated'));
  }

  bool isDeclinedMandatePayment(String message) {
    final lowerMessage = message.toLowerCase();

    return (lowerMessage.contains('e-mandate') || lowerMessage.contains('payment of')) &&
        lowerMessage.contains('declined');
  }

  FederalEMandateInfo? parseEMandateSubscription(String message) {
    if (!isMandateCreationNotification(message)) {
      return null;
    }

    final amountPattern = RegExp(
      r'(?:for\s+a\s+)?maximum\s+amount\s+of\s+Rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final match = amountPattern.firstMatch(message);
    if (match == null) return null;

    final amountStr = match.group(1)!.replaceAll(',', '');
    final amount = double.tryParse(amountStr);
    if (amount == null) return null;

    final datePattern = RegExp(r'starting\s+from\s+(\d{2}-\d{2}-\d{4})', caseSensitive: false);
    final startDate = datePattern.firstMatch(message)?.group(1);

    final merchantPattern = RegExp(
      r'(?:created\s+a\s+mandate\s+on|mandate\s+on)\s+([^.\n]+?)(?:\s+for|\s*$)',
      caseSensitive: false,
    );
    final mMatch = merchantPattern.firstMatch(message);
    final merchant = mMatch != null ? cleanMerchantName(mMatch.group(1)!.trim()) : 'Unknown Subscription';

    final umnPattern = RegExp(r'Mandate\s+Ref\s+No-?\s*([^.\s]+)', caseSensitive: false);
    final umn = umnPattern.firstMatch(message)?.group(1);

    return FederalEMandateInfo(
      amount: amount,
      nextDeductionDate: startDate,
      merchant: merchant,
      umn: umn,
    );
  }

  FederalEMandateInfo? parseFutureDebit(String message) {
    final lowerMessage = message.toLowerCase();

    if (!lowerMessage.contains('payment due') || !lowerMessage.contains('will be processed')) {
      return null;
    }

    final amountPattern = RegExp(r'INR\s+(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    final match = amountPattern.firstMatch(message);
    if (match == null) return null;

    final amountStr = match.group(1)!.replaceAll(',', '');
    final amount = double.tryParse(amountStr);
    if (amount == null) return null;

    final datePattern = RegExp(r'on\s+(\d{2}/\d{2}/\d{4})', caseSensitive: false);
    var dueDate = datePattern.firstMatch(message)?.group(1);
    if (dueDate != null) {
      try {
        final parts = dueDate.split('/');
        if (parts.length == 3) {
          dueDate = '${parts[0]}/${parts[1]}/${parts[2].substring(parts[2].length - 2)}';
        }
      } catch (_) {}
    }

    final merchantPattern = RegExp(r'for\s+([^.\n]+?)\s*,\s*INR', caseSensitive: false);
    final merMatch = merchantPattern.firstMatch(message);
    final merchant = merMatch != null ? cleanMerchantName(merMatch.group(1)!.trim()) : 'Unknown Subscription';

    return FederalEMandateInfo(
      amount: amount,
      nextDeductionDate: dueDate,
      merchant: merchant,
      umn: null,
    );
  }

  bool isTransactionMessageForTesting(String message) => isTransactionMessage(message);
}

class FederalEMandateInfo implements MandateInfo {
  @override
  final double amount;
  @override
  final String? nextDeductionDate;
  @override
  final String merchant;
  @override
  final String? umn;
  @override
  final String dateFormat = 'dd-MM-yyyy';

  const FederalEMandateInfo({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
  });
}
