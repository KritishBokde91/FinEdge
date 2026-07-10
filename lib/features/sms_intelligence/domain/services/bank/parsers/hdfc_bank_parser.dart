import 'package:finsight_ai/core/constants/compiled_patterns.dart';
import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// HDFC Bank specific parser.
///
/// Direct port of `parser-core/bank/HDFCBankParser.kt`.
/// Handles HDFC's unique message formats including:
/// - Standard debit/credit messages
/// - UPI transactions with VPA details
/// - Salary credits with company names
/// - E-Mandate notifications
/// - Card transactions
class HdfcBankParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'HDFC Bank';

  // ---------------------------------------------------------------------------
  // override fun canHandle(sender): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool canHandle(String sender) {
    final upperSender = sender.toUpperCase();

    // Common HDFC sender IDs
    const hdfcSenders = {'HDFCBK', 'HDFCBANK', 'HDFC', 'HDFCB'};

    // Direct match
    if (hdfcSenders.contains(upperSender)) return true;

    // DLT patterns
    return CompiledPatterns.hdfc.dltPatterns.any((p) => p.hasMatch(upperSender));
  }

  // ---------------------------------------------------------------------------
  // override fun extractMerchant(message, sender): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractMerchant(String message, String sender) {
    final lower = message.toLowerCase();

    // Check for HDFC Bank Card debit transactions —
    // "Spent Rs.xxx From HDFC Bank Card xxxx At [MERCHANT] On xxx"
    if (lower.contains('from hdfc bank card') &&
        lower.contains(' at ') &&
        lower.contains(' on ')) {
      final atIndex = lower.indexOf(' at ');
      final onIndex = lower.lastIndexOf(' on ');
      if (atIndex != -1 && onIndex != -1 && onIndex > atIndex) {
        final merchantStr = message.substring(atIndex + 4, onIndex).trim();
        if (merchantStr.isNotEmpty) return cleanMerchantName(merchantStr);
      }
    }

    // Check for "Txn Rs.X On HDFC Bank Card At [MERCHANT] by UPI" format
    if (lower.contains('txn') &&
        lower.contains('at ') &&
        lower.contains('card')) {
      final txnAtPattern = RegExp(
        r'At\s+(.+?)\s*(?:by\s+UPI|on\s+\d|$)',
        caseSensitive: false,
        dotAll: true,
      );
      final m = txnAtPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty) return cleanMerchantName(merchantStr);
      }
    }

    // Check for ATM withdrawals — extract location
    if (lower.contains('withdrawn')) {
      // Pattern: "At +18 Random Location" or "At ATM Location On"
      final atLocationPattern =
          RegExp(r'At\s+\+?([^O]+?)\s+On', caseSensitive: false);
      final m = atLocationPattern.firstMatch(message);
      if (m != null) {
        final location = m.group(1)!.trim();
        return location.isNotEmpty
            ? 'ATM at ${cleanMerchantName(location)}'
            : 'ATM';
      }
      return 'ATM'; // Fallback if no location found
    }

    // Check for generic ATM mentions (without "withdrawn")
    if (lower.contains('atm')) return 'ATM';

    // For credit card transactions (with BLOCK CC/PCC instruction)
    if (lower.contains('card') &&
        lower.contains(' at ') &&
        (lower.contains('block cc') || lower.contains('block pcc'))) {
      final atPattern = RegExp(
        r'at\s+([^@\s]+(?:@[^\s]+)?(?:\s+[^\s]+)?)(?:\s+by\s+|\s+on\s+|$)',
        caseSensitive: false,
      );
      final m = atPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        final cleanedMerchant = merchantStr.contains('@')
            ? _processVpaName(merchantStr.split('@').first.trim())
            : merchantStr;
        if (cleanedMerchant.isNotEmpty) return cleanMerchantName(cleanedMerchant);
      }
    }

    // Pattern 0: NEFT/RTGS credit
    // "for NEFT Cr-IFSCCODE-COMPANY NAME-BENEFICIARY-REF"
    if (lower.contains('neft') || lower.contains('rtgs')) {
      final neftPattern = RegExp(
        r'(?:NEFT|RTGS)\s+Cr-[A-Z]{4}0[A-Z0-9]{6}-([^-]+)',
        caseSensitive: false,
      );
      final m = neftPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty &&
            !merchantStr.split('').every((c) => '0123456789'.contains(c))) {
          return cleanMerchantName(merchantStr);
        }
      }
    }

    // Pattern 1: Salary credit
    // "for XXXXX-ABC-XYZ MONTH SALARY-COMPANY NAME"
    if (lower.contains('salary') && lower.contains('deposited')) {
      final m1 = CompiledPatterns.hdfc.salaryPattern.firstMatch(message);
      if (m1 != null) return cleanMerchantName(m1.group(1)!.trim());

      final m2 = CompiledPatterns.hdfc.simpleSalaryPattern.firstMatch(message);
      if (m2 != null) {
        final merchantStr = m2.group(1)!.trim();
        if (merchantStr.isNotEmpty &&
            !merchantStr.split('').every((c) => '0123456789'.contains(c))) {
          return cleanMerchantName(merchantStr);
        }
      }
    }

    // Pattern 2: "Info: UPI/merchant/category" format
    if (lower.contains('info:')) {
      final m = CompiledPatterns.hdfc.infoPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty &&
            !merchantStr.toLowerCase().startsWith('upi')) {
          return cleanMerchantName(merchantStr);
        }
      }
    }

    // Pattern 3: "VPA merchant@bank (Merchant Name)" format
    if (lower.contains('vpa')) {
      // Special case: "from VPA username@provider (UPI reference)" on credit
      if (lower.contains('from vpa') && lower.contains('credited')) {
        final fromVpaPattern = RegExp(
          r'from\s+VPA\s*([^@\s]+)@[^\s]+\s*\(UPI\s+\d+\)',
          caseSensitive: false,
        );
        final m = fromVpaPattern.firstMatch(message);
        if (m != null) {
          final vpaUsername = m.group(1)!.trim();
          if (vpaUsername.isNotEmpty) return cleanMerchantName(vpaUsername);
        }
      }

      // First try to get name in parentheses
      final m1 = CompiledPatterns.hdfc.vpaWithName.firstMatch(message);
      if (m1 != null) return cleanMerchantName(m1.group(1)!.trim());

      // Then try just the VPA username part
      final m2 = CompiledPatterns.hdfc.vpaPattern.firstMatch(message);
      if (m2 != null) {
        final vpaName = m2.group(1)!.trim();
        if (vpaName.length > 3 &&
            !vpaName.split('').every((c) => '0123456789'.contains(c))) {
          return cleanMerchantName(vpaName);
        }
      }
    }

    // Pattern 4: "spent on Card XX1234 at merchant on date"
    if (lower.contains('spent on card')) {
      final m = CompiledPatterns.hdfc.spentPattern.firstMatch(message);
      if (m != null) return cleanMerchantName(m.group(1)!.trim());
    }

    // Pattern 5: "debited for merchant on date"
    if (lower.contains('debited for')) {
      final m = CompiledPatterns.hdfc.debitForPattern.firstMatch(message);
      if (m != null) return cleanMerchantName(m.group(1)!.trim());
    }

    // Pattern 6: "To merchant name" (for UPI mandate)
    if (lower.contains('upi mandate')) {
      final m = CompiledPatterns.hdfc.mandatePattern.firstMatch(message);
      if (m != null) return cleanMerchantName(m.group(1)!.trim());
    }

    // Pattern 7: "towards [Merchant Name]" (for payment alerts)
    if (lower.contains('towards')) {
      final towardsPattern = RegExp(
        r'towards\s+([^\n]+?)(?:\s+UMRN|\s+ID:|\s+Alert:|$)',
        caseSensitive: false,
      );
      final m = towardsPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty) return cleanMerchantName(merchantStr);
      }
    }

    // Pattern 8: "For: [Description]" (for payment alerts)
    if (lower.contains('for:')) {
      final forColonPattern = RegExp(
        r'For:\s+([^\n]+?)(?:\s+From|\s+Via|$)',
        caseSensitive: false,
      );
      final m = forColonPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty) return cleanMerchantName(merchantStr);
      }
    }

    // Pattern 9: "for [Merchant Name]" (for future debit notifications)
    if (lower.contains('for ') && lower.contains('will be debited')) {
      final forPattern = RegExp(
        r'for\s+([^\n]+?)(?:\s+mandate|\s+will\s+be|\s+ID:|\s+Act:|$)',
        caseSensitive: false,
      );
      final m = forPattern.firstMatch(message);
      if (m != null) {
        final merchantStr = m.group(1)!.trim();
        if (merchantStr.isNotEmpty) return cleanMerchantName(merchantStr);
      }
    }

    // Fall back to generic extraction
    return super.extractMerchant(message, sender);
  }

  // ---------------------------------------------------------------------------
  // override fun extractTransactionType(message): TransactionType?
  // ---------------------------------------------------------------------------

  @override
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();

    // Use base class investment detection
    if (isInvestmentTransaction(lower)) return TransactionType.investment;

    // Credit card transactions — ONLY if message contains CC or PCC indicators
    if (lower.contains('block cc') || lower.contains('block pcc')) {
      return TransactionType.credit;
    }

    // Legacy pattern for older format that explicitly says "spent on card"
    if (lower.contains('spent on card') && !lower.contains('block dc')) {
      return TransactionType.credit;
    }

    // Credit card bill payments (regular expenses from bank account)
    if (lower.contains('payment') && lower.contains('credit card')) {
      return TransactionType.expense;
    }
    if (lower.contains('towards') && lower.contains('credit card')) {
      return TransactionType.expense;
    }

    // HDFC specific: "Sent Rs.X From HDFC Bank"
    if (lower.contains('sent') && lower.contains('from hdfc')) {
      return TransactionType.expense;
    }

    // HDFC specific: "Spent Rs.X From HDFC Bank Card" (debit card transactions)
    if (lower.contains('spent') && lower.contains('from hdfc bank card')) {
      return TransactionType.expense;
    }

    // Standard expense keywords
    if (lower.contains('debited')) return TransactionType.expense;
    if (lower.contains('withdrawn') && !lower.contains('block cc')) {
      return TransactionType.expense;
    }
    if (lower.contains('spent') && !lower.contains('card')) {
      return TransactionType.expense;
    }
    if (lower.contains('charged')) return TransactionType.expense;
    if (lower.contains('paid')) return TransactionType.expense;
    if (lower.contains('purchase')) return TransactionType.expense;

    // Income keywords
    if (lower.contains('credited')) return TransactionType.income;
    if (lower.contains('deposited')) return TransactionType.income;
    if (lower.contains('received')) return TransactionType.income;
    if (lower.contains('refund')) return TransactionType.income;
    if (lower.contains('cashback') && !lower.contains('earn cashback')) {
      return TransactionType.income;
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractReference(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractReference(String message) {
    // HDFC specific reference patterns
    final hdfcPatterns = [
      CompiledPatterns.hdfc.refSimple,
      CompiledPatterns.hdfc.upiRefNo,
      CompiledPatterns.hdfc.refNo,
      CompiledPatterns.hdfc.refEnd,
    ];

    for (final pattern in hdfcPatterns) {
      final m = pattern.firstMatch(message);
      if (m != null) return m.group(1)!.trim();
    }

    // Fall back to generic extraction
    return super.extractReference(message);
  }

  // ---------------------------------------------------------------------------
  // override fun extractAccountLast4(message): String?
  // ---------------------------------------------------------------------------

  @override
  String? extractAccountLast4(String message) {
    final parentResult = super.extractAccountLast4(message);
    if (parentResult != null) return parentResult;

    // Pattern for "Card x####" format — already exactly 4 digits
    final cardPattern = RegExp(r'Card\s+x(\d{4})', caseSensitive: false);
    final m1 = cardPattern.firstMatch(message);
    if (m1 != null) return m1.group(1);

    // Pattern for "HDFC Bank Credit Card ####" / "HDFC Bank Debit Card ####"
    // (refund SMS uses this format without the `x` mask prefix). The \b
    // after the capture group prevents greedily grabbing the first 4 of a
    // longer digit run.
    final plainCardPattern = RegExp(
      r'HDFC\s+Bank\s+(?:Credit|Debit)\s+Card\s+(\d{4})\b',
      caseSensitive: false,
    );
    final m2 = plainCardPattern.firstMatch(message);
    if (m2 != null) return m2.group(1);

    // Pattern for "BLOCK DC ####" format — already exactly 4 digits
    final blockDCPattern = RegExp(r'BLOCK\s+DC\s+(\d{4})', caseSensitive: false);
    final m3 = blockDCPattern.firstMatch(message);
    if (m3 != null) return m3.group(1);

    // Pattern for "HDFC Bank XXNNNN" format — require mask prefix, cap digits
    final hdfcBankPattern =
        RegExp(r'HDFC\s+Bank\s+([X*]+\d{3,6})', caseSensitive: false);
    final m4 = hdfcBankPattern.firstMatch(message);
    if (m4 != null) return extractLast4Digits(m4.group(1)!);

    // HDFC specific patterns from CompiledPatterns
    final hdfcPatterns = [
      CompiledPatterns.hdfc.accountDeposited,
      CompiledPatterns.hdfc.accountFrom,
      CompiledPatterns.hdfc.accountSimple,
      CompiledPatterns.hdfc.accountGeneric,
    ];

    for (final pattern in hdfcPatterns) {
      final m = pattern.firstMatch(message);
      if (m != null) return extractLast4Digits(m.group(1)!);
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // override fun extractBalance(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  @override
  double? extractBalance(String message) {
    // HDFC specific pattern for "Avl bal:INR NNNN.NN"
    final avlBalINRPattern = RegExp(
      r'Avl\s+bal:?\s*INR\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m1 = avlBalINRPattern.firstMatch(message);
    if (m1 != null) {
      final v = double.tryParse(m1.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern for "Available Balance: INR NNNN.NN"
    final availableBalINRPattern = RegExp(
      r'Available\s+Balance:?\s*INR\s*([0-9,]+(?:\.\d{2})?)',
      caseSensitive: false,
    );
    final m2 = availableBalINRPattern.firstMatch(message);
    if (m2 != null) {
      final v = double.tryParse(m2.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Pattern for "Bal Rs.NNNN.NN" or "Bal Rs NNNN.NN"
    final balRsPattern =
        RegExp(r'Bal\s+Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false);
    final m3 = balRsPattern.firstMatch(message);
    if (m3 != null) {
      final v = double.tryParse(m3.group(1)!.replaceAll(',', ''));
      if (v != null) return v;
    }

    // Fall back to base class patterns for Rs format
    return super.extractBalance(message);
  }

  // cleanMerchantName delegates to parent (no override needed)

  // ---------------------------------------------------------------------------
  // override fun isTransactionMessage(message): Boolean
  // ---------------------------------------------------------------------------

  @override
  bool isTransactionMessage(String message) {
    // Skip E-Mandate notifications
    if (isEMandateNotification(message)) return false;

    // Skip future debit notifications (subscription alerts, not transactions)
    if (isFutureDebitNotification(message)) return false;

    final lower = message.toLowerCase();

    // Skip NACH mandate processing notifications (not actual transactions)
    if (lower.contains('nach mandate') &&
        lower.contains('received') &&
        lower.contains('for processing')) {
      return false;
    }

    // Skip bill alert notifications
    // Example: "New Bill Alert: Your ... Bill ... is due on ..."
    if (lower.contains('bill alert') ||
        (lower.contains('bill') && lower.contains('is due on'))) {
      return false;
    }

    // Check for payment alerts (current transactions)
    if (lower.contains('payment alert')) {
      if (!lower.contains('will be')) return true;
    }

    // Skip payment request messages
    if (lower.contains('has requested') ||
        lower.contains('payment request') ||
        lower.contains('to pay, download') ||
        lower.contains('collect request') ||
        lower.contains('ignore if already paid')) {
      return false;
    }

    // Skip credit card payment confirmations
    if (lower.contains('received towards your credit card')) return false;

    // Skip credit card payment credited notifications
    if (lower.contains('payment') && lower.contains('credited to your card')) {
      return false;
    }

    // Skip OTP and promotional messages
    if (lower.contains('otp') ||
        lower.contains('one time password') ||
        lower.contains('verification code') ||
        lower.contains('offer') ||
        lower.contains('discount') ||
        lower.contains('cashback offer') ||
        lower.contains('win ')) {
      return false;
    }

    // HDFC specific transaction keywords
    const hdfcTransactionKeywords = [
      'debited', 'credited', 'withdrawn', 'deposited',
      'spent', 'received', 'transferred', 'paid',
      'sent',     // HDFC uses "Sent Rs.X From HDFC Bank"
      'deducted', // "deducted from" pattern
      'txn',      // HDFC uses "Txn Rs.X" for card transactions
      'refund',   // "Refund initiated: Amt: Rs.X on HDFC Bank Credit Card ####"
    ];

    return hdfcTransactionKeywords.any((kw) => lower.contains(kw));
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // E-Mandate / Subscription Logic
  // ══════════════════════════════════════════════════════════════════════════════

  /// Parses E-Mandate subscription information from HDFC messages.
  HdfcEMandateInfo? parseEMandateSubscription(String message) {
    if (!isEMandateNotification(message)) return null;

    // Extract amount — Patterns: "Rs.1050.00", "INR 59.00"
    final amountPatterns = [
      RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    double? amount;
    for (final p in amountPatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        amount = double.tryParse(m.group(1)!.replaceAll(',', ''));
        if (amount != null) break;
      }
    }

    if (amount == null) return null;

    // Extract merchant
    var merchant = 'Unknown Subscription';
    final merchantPatterns = [
      RegExp(
        r'towards\s+([^.\n]+?)(?:\s+from|\s+A/c|\s+UMRN|\s+ID:|\s+Alert:|\s*\.|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'for\s+([^.\n]+?)(?:\s+mandate|\s+will\s+be|\s+ID:|\s+Act:|\s*\.|$)',
        caseSensitive: false,
      ),
      RegExp(r'Info:\s*([^.\n]+?)(?:\s*$)', caseSensitive: false),
      RegExp(r'To\s+([^.\n]+?)(?:\s+UPI|,|$)', caseSensitive: false),
    ];

    for (final p in merchantPatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        final name = cleanMerchantName(m.group(1)!.trim());
        if (isValidMerchantName(name) && name.length > 2) {
          merchant = name;
          break;
        }
      }
    }

    // Extract next deduction date
    final datePatterns = [
      RegExp(r'on\s+(\d{2}-\w{3}-\d{2,4})', caseSensitive: false),
      RegExp(r'date[:\s]+(\d{2}/\d{2}/\d{2,4})', caseSensitive: false),
      RegExp(r'(\d{2}-\d{2}-\d{4})'),
      RegExp(r'(\d{2}/\d{2}/\d{2,4})'),
    ];

    String? nextDeductionDate;
    for (final p in datePatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        nextDeductionDate = m.group(1);
        break;
      }
    }

    // Extract UMN (Unique Mandate Number)
    final umnPatterns = [
      RegExp(r'UMN[:\s]+([^.\s]+)', caseSensitive: false),
      RegExp(r'UMRN[:\s]+([^.\s]+)', caseSensitive: false),
    ];
    String? umn;
    for (final p in umnPatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        umn = m.group(1);
        break;
      }
    }

    return HdfcEMandateInfo(
      amount: amount,
      nextDeductionDate: nextDeductionDate,
      merchant: merchant,
      umn: umn,
    );
  }

  /// Parses future debit notification from HDFC messages.
  /// These are alerts for upcoming subscription charges.
  HdfcEMandateInfo? parseFutureDebit(String message) {
    if (!isFutureDebitNotification(message)) return null;

    // Extract amount
    final amountPatterns = [
      RegExp(r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'INR\s*([0-9,]+(?:\.\d{2})?)', caseSensitive: false),
    ];

    double? amount;
    for (final p in amountPatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        amount = double.tryParse(m.group(1)!.replaceAll(',', ''));
        if (amount != null) break;
      }
    }

    if (amount == null) return null;

    // Extract merchant
    var merchant = 'Unknown Subscription';
    final merchantPatterns = [
      RegExp(
        r'for\s+([^.\n]+?)(?:\s+mandate|\s+will\s+be|\s+ID:|\s+Act:|\s*\.|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'towards\s+([^.\n]+?)(?:\s+from|\s+A/c|\s+UMRN|\s+ID:|\s*\.|$)',
        caseSensitive: false,
      ),
    ];

    for (final p in merchantPatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        final name = cleanMerchantName(m.group(1)!.trim());
        if (isValidMerchantName(name) && name.length > 2) {
          merchant = name;
          break;
        }
      }
    }

    // Extract next deduction date
    final datePatterns = [
      RegExp(r'on\s+(\d{2}-\w{3}-\d{2,4})', caseSensitive: false),
      RegExp(r'on\s+(\d{2}/\d{2}/\d{2,4})', caseSensitive: false),
      RegExp(r'(\d{2}-\d{2}-\d{4})'),
    ];

    String? nextDeductionDate;
    for (final p in datePatterns) {
      final m = p.firstMatch(message);
      if (m != null) {
        nextDeductionDate = m.group(1);
        break;
      }
    }

    return HdfcEMandateInfo(
      amount: amount,
      nextDeductionDate: nextDeductionDate,
      merchant: merchant,
      umn: null,
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  String _processVpaName(String vpaName) {
    // Clean up common UPI prefixes/suffixes
    if (vpaName.toLowerCase().endsWith('qr')) {
      return vpaName.substring(0, vpaName.length - 2);
    }
    return vpaName;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Support types
// ────────────────────────────────────────────────────────────────────────────

/// Port of `HDFCBankParser.EMandateInfo`.
class HdfcEMandateInfo implements MandateInfo {
  @override
  final double amount;
  @override
  final String? nextDeductionDate;
  @override
  final String merchant;
  @override
  final String? umn;
  @override
  final String dateFormat = 'dd/MM/yy';

  const HdfcEMandateInfo({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
  });
}
