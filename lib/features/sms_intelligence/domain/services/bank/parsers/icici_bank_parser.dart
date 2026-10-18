import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// Parser for ICICI Bank SMS messages.
///
/// Direct port of `parser-core/bank/ICICIBankParser.kt`.
///
/// Supported formats:
/// - Debit: "Your account has been successfully debited with Rs xxx.00"
/// - Credit: "Acct XXxxx is credited with Rs xxx.00"
/// - UPI: "ICICI Bank Acct XXxxx debited for Rs xxx.00"
/// - Cash Deposit: "Cash deposit transaction of Rs xxx..."
/// - AutoPay transactions
/// - Multi-currency: "USD 11.80 spent using ICICI Bank Card"
///
/// Common senders: XX-ICICIB-S, ICICIB, ICICIBANK
class IciciBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'ICICI Bank';

  // ---------------------------------------------------------------------------
  // override fun parse(smsBody, sender, timestamp): ParsedTransaction?
  // ---------------------------------------------------------------------------

  @override
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    // Skip non-transaction messages
    if (!isTransactionMessage(smsBody)) return null;

    final amount = extractAmount(smsBody);
    if (amount == null) return null;

    // Detect ICICI's dual-account transfer pattern (e.g. IMPS where the SMS
    // mentions both `Acct XX debited` and `Acct YY credited` in the same body).
    // Routes such SMS to TRANSFER so a later pipeline pass can dedupe against
    // the credit-side SMS using the IMPS/NEFT reference.
    final transferAccounts = _extractTransferAccounts(smsBody);

    final type = transferAccounts != null
        ? TransactionType.transfer
        : extractTransactionType(smsBody);
    if (type == null) return null;

    // Extract currency dynamically for multi-currency support
    final currency = _extractCurrencyFromMessage(smsBody) ?? 'INR';

    // Extract available limit for credit card transactions
    final availableLimit =
        type == TransactionType.credit ? extractAvailableLimit(smsBody) : null;

    final merchant = transferAccounts != null
        ? _labelTransferRail(smsBody)
        : extractMerchant(smsBody, sender);

    return ParsedTransaction(
      amount: amount,
      type: type,
      merchant: merchant,
      reference: extractReference(smsBody),
      accountLast4:
          transferAccounts?.$1 ?? extractAccountLast4(smsBody),
      balance: extractBalance(smsBody),
      creditLimit: availableLimit,
      smsBody: smsBody,
      sender: sender,
      timestamp: timestamp,
      bankName: getBankName(),
      isFromCard: detectIsCard(smsBody),
      currency: currency,
      fromAccount: transferAccounts?.$1,
      toAccount: transferAccounts?.$2,
    );
  }

  String _labelTransferRail(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('imps')) return 'IMPS Transfer';
    if (lower.contains('neft')) return 'NEFT Transfer';
    return 'Account Transfer';
  }

  /// Detects ICICI's `Acct XX debited ... & Acct YY credited` IMPS/NEFT pattern
  /// and returns (fromAccount, toAccount) when both account references appear
  /// in the same SMS and differ. Returns null otherwise.
  (String, String)? _extractTransferAccounts(String message) {
    final debitedAcctPattern = RegExp(
      r'Acct\s+([X*\d]+)\s+(?:is\s+)?debited',
      caseSensitive: false,
    );
    final creditedAcctPattern = RegExp(
      r'Acct\s+([X*\d]+)\s+(?:is\s+)?credited',
      caseSensitive: false,
    );

    final debitedMatch = debitedAcctPattern.firstMatch(message);
    if (debitedMatch == null) return null;

    final creditedMatch = creditedAcctPattern.firstMatch(message);
    if (creditedMatch == null) return null;

    final fromAcct = extractLast4Digits(debitedMatch.group(1)!);
    final toAcct = extractLast4Digits(creditedMatch.group(1)!);

    if (fromAcct == null ||
        fromAcct.isEmpty ||
        toAcct == null ||
        toAcct.isEmpty ||
        fromAcct == toAcct) {
      return null;
    }

    return (fromAcct, toAcct);
  }

  /// Extract currency from ICICI transaction messages.
  /// Handles formats like "USD 11.80 spent" or "EUR 50.00 spent".
  String? _extractCurrencyFromMessage(String message) {
    // Pattern for "USD 11.80 spent" format
    final currencySpentPattern = RegExp(
      r'([A-Z]{3})\s+[0-9,]+(?:\.\d{2})?\s+spent',
      caseSensitive: false,
    );
    final m = currencySpentPattern.firstMatch(message);
    if (m != null) {
      final currency = m.group(1)!.toUpperCase();
      // Validate: 3 letters, not a month abbreviation
      final months = {'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'};
      if (currency.length == 3 && !months.contains(currency)) return currency;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun canHandle(sender): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool canHandle(String sender) {
    final s = sender.toUpperCase();
    return s.contains('ICICI') ||
        s.contains('ICICIB') ||
        // DLT patterns for transactions (-S suffix)
        RegExp(r'^[A-Z]{2}-ICICIB-S$').hasMatch(s) ||
        RegExp(r'^[A-Z]{2}-ICICI-S$').hasMatch(s) ||
        // Other DLT patterns
        RegExp(r'^[A-Z]{2}-ICICIB-[TPG]$').hasMatch(s) ||
        // Legacy patterns
        RegExp(r'^[A-Z]{2}-ICICIB$').hasMatch(s) ||
        RegExp(r'^[A-Z]{2}-ICICI$').hasMatch(s) ||
        // Direct sender IDs
        s == 'ICICIB' ||
        s == 'ICICIBANK';
  }

  // ---------------------------------------------------------------------------
  // override fun extractAmount(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractAmount(String message) {
    // Pattern 1: Multi-currency support - "USD 11.80 spent" or "EUR 50.00 spent"
    final multiCurrencySpentPattern = RegExp(
      r'[A-Z]{3}\s+([0-9,]+(?:\.\d{2})?)\s+spent',
      caseSensitive: false,
    );
    final m1 = multiCurrencySpentPattern.firstMatch(message);
    if (m1 != null) {
      final v = double.tryParse(m1.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 2: "Rs xxx.xx spent" or "INR xxx.xx spent" (INR card transactions)
    final inrSpentPattern = RegExp(
      r'(?:Rs\.?|INR)\s+([0-9,]+(?:\.\d{2})?)\s+spent',
      caseSensitive: false,
    );
    final m2 = inrSpentPattern.firstMatch(message);
    if (m2 != null) {
      final v = double.tryParse(m2.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 3: "debited with Rs xxx.00"
    final debitWithPattern = RegExp(
      r'debited\s+with\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m3 = debitWithPattern.firstMatch(message);
    if (m3 != null) {
      final v = double.tryParse(m3.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 4: "debited for Rs xxx.00"
    final debitForPattern = RegExp(
      r'debited\s+for\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m4 = debitForPattern.firstMatch(message);
    if (m4 != null) {
      final v = double.tryParse(m4.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 5: "credited with Rs xxx.00"
    final creditWithPattern = RegExp(
      r'credited\s+with\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m5 = creditWithPattern.firstMatch(message);
    if (m5 != null) {
      final v = double.tryParse(m5.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 6: "credited:Rs. xxx.xx" (colon format for cash deposits)
    final creditColonPattern = RegExp(
      r'credited:\s*Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m6 = creditColonPattern.firstMatch(message);
    if (m6 != null) {
      final v = double.tryParse(m6.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Fall back to base class patterns
    return super.extractAmount(message);
  }

  // ---------------------------------------------------------------------------
  // override fun extractMerchant(message, sender): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractMerchant(String message, String sender) {
    final lower = message.toLowerCase();

    // Pattern 0: NEFT/RTGS transfer to beneficiary
    if (lower.contains('credited to the beneficiary') ||
        lower.contains('credited to beneficiary')) {
      return 'NEFT Transfer';
    }

    // Pattern 0b: Incoming NEFT credit - "Info NEFT-<refcode>-<PAYER NAME>"
    // The payer name follows the NEFT reference code (after the last hyphen).
    final neftCreditPattern = RegExp(
      r'Info\s+NEFT-[A-Za-z0-9]+-(.+?)(?:\.|$)',
      caseSensitive: false,
    );
    final mNeft = neftCreditPattern.firstMatch(message);
    if (mNeft != null) {
      final merchantStr = cleanMerchantName(mNeft.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 1: Salary transactions - "Info INF*...*...* SAL ..."
    final salaryPattern = RegExp(
      r'Info\s+INF\*[^*]+\*[^*]*SAL[^.]*',
      caseSensitive: false,
    );
    if (salaryPattern.hasMatch(message)) return 'Salary';

    // Pattern 2: NFS Cash Withdrawal — various ATM withdrawal formats
    if (lower.contains('nfscash wdl') ||
        lower.contains('nfs cash wdl') ||
        lower.contains('nfs*cash wdl') ||
        lower.contains('cash wdl') ||
        lower.contains('nfscash')) {
      return 'Cash Withdrawal';
    }

    // Pattern 2a: ATM cash withdrawal marker — "CAM*<code>*"
    final camWithdrawalPattern = RegExp(r'\bCAM\*[A-Za-z0-9]+\*?',
        caseSensitive: false);
    if (camWithdrawalPattern.hasMatch(message)) return 'ATM Withdrawal';

    // Pattern 2b: Bill-pay biller — "InfoBIL*<biller name>"
    final infoBilPattern = RegExp(
      r'InfoBIL\*(.+?)(?=\.|\s*Av[bl]\s*Bal|$)',
      caseSensitive: false,
    );
    final mBil = infoBilPattern.firstMatch(message);
    if (mBil != null) {
      final merchantStr = cleanMerchantName(mBil.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 3: Card transactions - "on DD-Mon-YY at MERCHANT NAME. Avl"
    // or "on DD-Mon-YY on MERCHANT NAME"
    final cardMerchantPattern = RegExp(
      r'on\s+\d{1,2}-\w{3}-\d{2}\s+(?:at|on)\s+([^.]+?)(?:\.|\s+Avl|$)',
      caseSensitive: false,
    );
    final mCard = cardMerchantPattern.firstMatch(message);
    if (mCard != null) {
      final merchantStr = cleanMerchantName(mCard.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern: "for UPI-REFNO-MERCHANT" (credit card UPI transactions)
    final upiMerchantPattern = RegExp(
      r'for\s+UPI-\d+-([A-Za-z][\w\s]*?)(?:\.|$|\s+To\s)',
      caseSensitive: false,
    );
    final mUpi = upiMerchantPattern.firstMatch(message);
    if (mUpi != null) {
      final merchantStr = cleanMerchantName(mUpi.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 4: ACH/NACH dividend payments — "Info ACH*COMPANY NAME*XXX"
    final achNachPattern = RegExp(
      r'Info\s+(?:ACH|NACH)\*([^*]+)\*',
      caseSensitive: false,
    );
    final mAch = achNachPattern.firstMatch(message);
    if (mAch != null) {
      final companyName = cleanMerchantName(mAch.group(1)!.trim());
      return '$companyName Dividend';
    }

    // Pattern 5: "towards <merchant> for"
    final towardsPattern = RegExp(
      r'towards\s+([^.\n]+?)\s+for',
      caseSensitive: false,
    );
    final mTowards = towardsPattern.firstMatch(message);
    if (mTowards != null) {
      final merchantStr = cleanMerchantName(mTowards.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 6: "from <name>. UPI"
    final fromUpiPattern = RegExp(
      r'from\s+([^.\n]+?)\.\s*UPI',
      caseSensitive: false,
    );
    final mFrom = fromUpiPattern.firstMatch(message);
    if (mFrom != null) {
      final merchantStr = cleanMerchantName(mFrom.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 7: "; <name> credited. UPI"
    final creditedPattern = RegExp(
      r';\s*([^.\n]+?)\s+credited\.\s*UPI',
      caseSensitive: false,
    );
    final mCredited = creditedPattern.firstMatch(message);
    if (mCredited != null) {
      final merchantStr = cleanMerchantName(mCredited.group(1)!.trim());
      if (isValidMerchantName(merchantStr)) return merchantStr;
    }

    // Pattern 8: Cash deposit via "Info BY CASH" pattern
    if (lower.contains('info by cash')) return 'Cash Deposit';

    // Pattern 9: AutoPay specific - extract service name
    if (lower.contains('autopay')) {
      if (lower.contains('google play')) return 'Google Play Store';
      if (lower.contains('netflix')) return 'Netflix';
      if (lower.contains('spotify')) return 'Spotify';
      if (lower.contains('amazon prime')) return 'Amazon Prime';
      if (lower.contains('disney') || lower.contains('hotstar')) {
        return 'Disney+ Hotstar';
      }
      if (lower.contains('youtube')) return 'YouTube Premium';
      return 'AutoPay Subscription';
    }

    // Fall back to base class patterns
    return super.extractMerchant(message, sender);
  }

  // ---------------------------------------------------------------------------
  // override fun extractAccountLast4(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractAccountLast4(String message) {
    final parent = super.extractAccountLast4(message);
    if (parent != null) return parent;

    // Pattern 1: "ICICI Bank Card XXNNNN"
    final cardPattern = RegExp(
      r'ICICI\s+Bank\s+Card\s+([X*\d]+)',
      caseSensitive: false,
    );
    final m1 = cardPattern.firstMatch(message);
    if (m1 != null) return extractLast4Digits(m1.group(1)!);

    // Pattern 2: "ICICI Bank Credit Card XX1234"
    final creditCardPattern = RegExp(
      r'ICICI\s+Bank\s+Credit\s+Card\s+([X*\d]+)',
      caseSensitive: false,
    );
    final m2 = creditCardPattern.firstMatch(message);
    if (m2 != null) return extractLast4Digits(m2.group(1)!);

    // Pattern 3: "ICICI Bank Account XXNNNN"
    final accountPattern = RegExp(
      r'ICICI\s+Bank\s+Account\s+([X*\d]+)',
      caseSensitive: false,
    );
    final m3 = accountPattern.firstMatch(message);
    if (m3 != null) return extractLast4Digits(m3.group(1)!);

    // Pattern 4: "ICICI Bank Acct XXNNNN"
    final bankAcctPattern = RegExp(
      r'ICICI\s+Bank\s+Acct\s+([X*\d]+)',
      caseSensitive: false,
    );
    final m4 = bankAcctPattern.firstMatch(message);
    if (m4 != null) return extractLast4Digits(m4.group(1)!);

    // Pattern 5: "ICICI Bank Acc XX921"
    final bankAccPattern = RegExp(
      r'ICICI\s+Bank\s+Acc\s+([X*\d]+)',
      caseSensitive: false,
    );
    final m5 = bankAccPattern.firstMatch(message);
    if (m5 != null) return extractLast4Digits(m5.group(1)!);

    // Pattern 6: "Acct XX1234" or "Acct *1234"
    final acctPattern = RegExp(
      r'Acct\s+([X*\d]+)(?:\s|$|[,;.])',
      caseSensitive: false,
    );
    final m6 = acctPattern.firstMatch(message);
    if (m6 != null) return extractLast4Digits(m6.group(1)!);

    // Pattern 7: "Acc XX921"
    final accPattern = RegExp(
      r'Acc\s+([X*\d]+)(?:\s|$|[,;.])',
      caseSensitive: false,
    );
    final m7 = accPattern.firstMatch(message);
    if (m7 != null) return extractLast4Digits(m7.group(1)!);

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractBalance(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractBalance(String message) {
    // Pattern 1: "Available Balance is Rs. 28,076.14" (with "is" keyword)
    final availBalIsPattern = RegExp(
      r'Available\s+Balance\s+is\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m1 = availBalIsPattern.firstMatch(message);
    if (m1 != null) {
      final v = double.tryParse(m1.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 2: "Avl Bal Rs 10,000.00" or "Avb Bal Rs 10,000.00" (typo variant)
    final avlBalPattern = RegExp(
      r'Av[lb]\s+Bal\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m2 = avlBalPattern.firstMatch(message);
    if (m2 != null) {
      final v = double.tryParse(m2.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern 3: "Updated Bal: Rs 5,000.00"
    final updatedBalPattern = RegExp(
      r'Updated\s+Bal[:\s]+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m3 = updatedBalPattern.firstMatch(message);
    if (m3 != null) {
      final v = double.tryParse(m3.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Fall back to base class
    return super.extractBalance(message);
  }

  // ---------------------------------------------------------------------------
  // override fun extractReference(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractReference(String message) {
    // Pattern 0: "IMPS:xxxxx" — keep ahead of UPI so dual-rail SMS pick IMPS ref
    final impsPattern = RegExp(r'IMPS:([A-Za-z0-9]+)', caseSensitive: false);
    final m0 = impsPattern.firstMatch(message);
    if (m0 != null) return m0.group(1);

    // Pattern 1: "RRN 1xxxxx3xxxxx"
    final rrnPattern = RegExp(r'RRN\s+([A-Za-z0-9]+)', caseSensitive: false);
    final m1 = rrnPattern.firstMatch(message);
    if (m1 != null) return m1.group(1);

    // Pattern 2: "UPI:5xxxxx8xxxxx"
    final upiPattern = RegExp(r'UPI:([A-Za-z0-9]+)', caseSensitive: false);
    final m2 = upiPattern.firstMatch(message);
    if (m2 != null) return m2.group(1);

    // Pattern 3: "transaction reference no.MCDA001746000000"
    final txnRefPattern = RegExp(
      r'transaction\s+reference\s+no\.?([A-Z0-9]+)',
      caseSensitive: false,
    );
    final m3 = txnRefPattern.firstMatch(message);
    if (m3 != null) return m3.group(1);

    // Fall back to base class
    return super.extractReference(message);
  }

  // ---------------------------------------------------------------------------
  // override fun isTransactionMessage(message): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool isTransactionMessage(String message) {
    final lower = message.toLowerCase();

    // Skip cash deposit confirmation messages (duplicate of actual credit notification)
    if (lower.contains('cash deposit transaction') &&
        lower.contains('has been completed')) {
      return false;
    }

    // Skip payment due reminders
    if (lower.contains('is due by')) return false;

    // Skip future debit notifications (not actual transactions yet)
    if (lower.contains('will be debited')) return false;

    // Skip credit card bill payment confirmations
    if (lower.contains('has been received on your icici bank credit card')) {
      return false;
    }

    // Check for ICICI-specific transaction keywords
    const iciciKeywords = [
      'debited with',
      'debited for',
      'credited with',
      'credited:',    // For "credited:Rs." format
      'autopay',
      'your account has been',
      'inr',          // For "INR xxx spent" pattern
      'spent using',  // For card transactions
    ];

    if (iciciKeywords.any((kw) => lower.contains(kw))) return true;

    // Fall back to base class for standard checks
    return super.isTransactionMessage(message);
  }

  // ---------------------------------------------------------------------------
  // override fun extractTransactionType(message): TransactionType?
  // ---------------------------------------------------------------------------

  @override
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();

    // NEFT/RTGS transfer confirmation — "credited to the beneficiary account"
    // The sender's money was sent OUT to the beneficiary.
    if (lower.contains('credited to the beneficiary') ||
        lower.contains('credited to beneficiary')) {
      return TransactionType.expense;
    }

    // Credit card transactions — "ICICI Bank Credit Card" or
    // "ICICI Bank Card" + spent, combined with spent/debited
    if ((lower.contains('icici bank credit card') ||
            (lower.contains('icici bank card') && lower.contains('spent'))) &&
        (lower.contains('spent') || lower.contains('debited'))) {
      return TransactionType.credit;
    }

    // Cash deposit via "Info BY CASH" is income
    if (lower.contains('info by cash')) return TransactionType.income;

    // Fall back to base class for standard checks
    return super.extractTransactionType(message);
  }
}
