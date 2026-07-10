import 'package:finsight_ai/core/constants/compiled_patterns.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/mandate_info.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';

/// Base abstract class for Indian bank parsers.
///
/// Direct port of `parser-core/bank/BaseIndianBankParser.kt`.
/// Handles common patterns across Indian banks (INR currency, UPI, mandate, etc.).
abstract class BaseIndianBankParser extends BankParser {
  @override
  String getCurrency() => 'INR';

  // ---------------------------------------------------------------------------
  // override fun isInvestmentTransaction(lowerMessage): Boolean
  // ---------------------------------------------------------------------------

  /// Credits to a bank account are income, not investment (ACH dividends,
  /// vendor payments, etc.). Only uses "credited" and "deposited" — "received"
  /// is ambiguous.
  @override
  bool isInvestmentTransaction(String lowerMessage) {
    if (lowerMessage.contains('credited') ||
        lowerMessage.contains('deposited')) {
      return false;
    }
    return super.isInvestmentTransaction(lowerMessage);
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // Unified Mandate / Subscription Logic
  // ══════════════════════════════════════════════════════════════════════════════

  /// Checks if this is an E-Mandate notification (not a transaction).
  bool isEMandateNotification(String message) {
    final lower = message.toLowerCase();
    return lower.contains('e-mandate') ||
        lower.contains('upi-mandate') ||
        (lower.contains('mandate') && lower.contains('successfully created'));
  }

  /// Checks if this is a future debit notification (subscription alert, not a
  /// current transaction).
  bool isFutureDebitNotification(String message) {
    final lower = message.toLowerCase();
    return lower.contains('will be debited') ||
        lower.contains('mandate set for') ||
        (lower.contains('upcoming') && lower.contains('mandate'));
  }

  /// Parses combined Mandate / E-Mandate / UPI-Mandate subscription information.
  /// Returns a general [MandateInfo] implementation.
  MandateInfo? parseMandateSubscription(String message) {
    if (!isEMandateNotification(message) && !isFutureDebitNotification(message)) {
      return null;
    }

    // 1. Extract amount — Patterns: "Rs.1050.00", "INR 59.00", "Rs 123.45"
    final double? amount = _parseAmount(
      CompiledPatterns.amount.inrPattern.firstMatch(message),
    ) ??
        _parseAmount(CompiledPatterns.amount.rsPattern.firstMatch(message));

    if (amount == null) return null;

    // 2. Extract merchant
    // Patterns: "towards Google Play", "for Netflix", "Info: Spotify"
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
      RegExp(
        r'Info:\s*([^.\n]+?)(?:\s*$)',
        caseSensitive: false,
      ),
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

    // 3. Extract date (for future debits)
    // Matches DD-MMM-YY, dd/MM/yyyy formats common in Indian banks
    final datePattern = RegExp(
      r'(?:on|for)\s+(' +
          CompiledPatterns.date.ddMmmYy.pattern +
          r'|' +
          CompiledPatterns.date.ddMmYyyy.pattern +
          r')',
      caseSensitive: false,
    );
    final dateStr = datePattern.firstMatch(message)?.group(1);

    // 4. Extract UMN (Unique Mandate Number) if present
    final umnPattern = RegExp(r'UMN[:\s]+([^.\s]+)', caseSensitive: false);
    final umn = umnPattern.firstMatch(message)?.group(1);

    return _MandateInfoImpl(
      amount: amount,
      nextDeductionDate: dateStr,
      merchant: merchant,
      umn: umn,
      dateFormat: 'dd-MMM-yy',
    );
  }

  double? _parseAmount(RegExpMatch? match) {
    if (match == null) return null;
    final str = match.group(1)!.replaceAll(',', '');
    return double.tryParse(str);
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // Unified Balance Update Logic
  // ══════════════════════════════════════════════════════════════════════════════

  /// Checks if this is a balance update notification (not a transaction).
  bool isBalanceUpdateNotification(String message) {
    final lower = message.toLowerCase();

    final hasBalanceKeyword = lower.contains('available bal') ||
        lower.contains('avl bal') ||
        lower.contains('account balance') ||
        lower.contains('a/c balance') ||
        lower.contains('updated balance');

    final hasTxnKeyword = lower.contains('debited') ||
        lower.contains('credited') ||
        lower.contains('withdrawn') ||
        lower.contains('deposited') ||
        lower.contains('spent') ||
        lower.contains('transferred') ||
        lower.contains('payment of');

    return hasBalanceKeyword && !hasTxnKeyword;
  }

  /// Parses generic balance update notification.
  BaseBalanceUpdateInfo? parseBalanceUpdate(String message) {
    if (!isBalanceUpdateNotification(message)) return null;

    final accountLast4 = extractAccountLast4(message);
    final balance = extractBalance(message);
    if (balance == null) return null;

    return BaseBalanceUpdateInfo(
      bankName: getBankName(),
      accountLast4: accountLast4,
      balance: balance,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // Common Helper Methods
  // ══════════════════════════════════════════════════════════════════════════════

  /// Converts a month abbreviation to its integer number (1–12).
  int getMonthNumber(String monthAbbr) {
    switch (monthAbbr.toUpperCase()) {
      case 'JAN':
        return 1;
      case 'FEB':
        return 2;
      case 'MAR':
        return 3;
      case 'APR':
        return 4;
      case 'MAY':
        return 5;
      case 'JUN':
        return 6;
      case 'JUL':
        return 7;
      case 'AUG':
        return 8;
      case 'SEP':
        return 9;
      case 'OCT':
        return 10;
      case 'NOV':
        return 11;
      case 'DEC':
        return 12;
      default:
        return 1;
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Support types (mirrors Kotlin inner data classes)
// ────────────────────────────────────────────────────────────────────────────

/// Port of `BaseIndianBankParser.BaseBalanceUpdateInfo`.
class BaseBalanceUpdateInfo {
  final String bankName;
  final String? accountLast4;
  final double balance;
  final DateTime? asOfDate;

  const BaseBalanceUpdateInfo({
    required this.bankName,
    this.accountLast4,
    required this.balance,
    this.asOfDate,
  });
}

/// Anonymous [MandateInfo] implementation returned by [parseMandateSubscription].
class _MandateInfoImpl implements MandateInfo {
  @override
  final double amount;
  @override
  final String? nextDeductionDate;
  @override
  final String merchant;
  @override
  final String? umn;
  @override
  final String dateFormat;

  const _MandateInfoImpl({
    required this.amount,
    required this.nextDeductionDate,
    required this.merchant,
    required this.umn,
    required this.dateFormat,
  });
}
