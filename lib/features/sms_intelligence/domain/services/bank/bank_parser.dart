import 'package:finsight_ai/core/constants/compiled_patterns.dart';
import 'package:finsight_ai/core/constants/parser_constants.dart';
import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';

/// Base class for bank-specific message parsers.
///
/// Direct port of `parser-core/bank/BankParser.kt`.
/// Every method, every condition, every keyword list is preserved verbatim.
/// Subclasses override individual extraction methods for bank-specific behaviour.
abstract class BankParser {
  // ---------------------------------------------------------------------------
  // Abstract interface (must be implemented by every bank parser)
  // ---------------------------------------------------------------------------

  /// Returns the name of the bank this parser handles.
  String getBankName();

  /// Checks if this parser can handle messages from the given [sender].
  bool canHandle(String sender);

  // ---------------------------------------------------------------------------
  // Overridable defaults
  // ---------------------------------------------------------------------------

  /// Returns the currency used by this bank.
  /// Defaults to INR for Indian banks. International banks should override.
  String getCurrency() => 'INR';

  /// Whether this parser represents a mobile-money wallet whose SMS carries a
  /// running balance but no per-account number (e.g. eMola, M-Pesa Mozambique).
  /// When true the app derives a single service-level account row from the
  /// balance instead of requiring an accountLast4. Defaults to false.
  bool isMobileWallet() => false;

  // ---------------------------------------------------------------------------
  // fun parse(smsBody, sender, timestamp): ParsedTransaction?
  // ---------------------------------------------------------------------------

  /// Parses an SMS message and extracts transaction information.
  /// Returns null if the message cannot be parsed.
  ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    if (!isTransactionMessage(smsBody)) return null;

    final amount = extractAmount(smsBody);
    if (amount == null) return null;

    final type = extractTransactionType(smsBody);
    if (type == null) return null;

    // Extract available limit for credit card transactions
    final availableLimit =
        (type == TransactionType.credit) ? extractAvailableLimit(smsBody) : null;

    final rawAccountLast4 = extractAccountLast4(smsBody);
    final safeAccountLast4 = rawAccountLast4 != null
        ? (extractLast4Digits(rawAccountLast4) ?? rawAccountLast4)
        : null;

    return ParsedTransaction(
      amount: amount,
      type: type,
      merchant: extractMerchant(smsBody, sender),
      reference: extractReference(smsBody),
      accountLast4: safeAccountLast4,
      balance: extractBalance(smsBody),
      creditLimit: availableLimit,
      smsBody: smsBody,
      sender: sender,
      timestamp: timestamp,
      bankName: getBankName(),
      isFromCard: detectIsCard(smsBody),
      currency: getCurrency(),
      isMobileWallet: isMobileWallet(),
    );
  }

  // ---------------------------------------------------------------------------
  // fun isTransactionMessage(message): Boolean
  // ---------------------------------------------------------------------------

  /// Checks if the message is a transaction message (not OTP, promotional, etc.)
  bool isTransactionMessage(String message) {
    final lower = message.toLowerCase();

    // Skip OTP messages
    if (lower.contains('otp') ||
        lower.contains('one time password') ||
        lower.contains('verification code')) {
      return false;
    }

    // Skip promotional messages
    if (lower.contains('offer') ||
        lower.contains('discount') ||
        lower.contains('cashback offer') ||
        lower.contains('win ')) {
      return false;
    }

    // Skip payment request messages (common across banks)
    if (lower.contains('has requested') ||
        lower.contains('payment request') ||
        lower.contains('collect request') ||
        lower.contains('requesting payment') ||
        lower.contains('requests rs') ||
        lower.contains('ignore if already paid')) {
      return false;
    }

    // Skip merchant payment acknowledgments
    if (lower.contains('have received payment')) {
      return false;
    }

    // Skip payment reminder/due messages
    if (lower.contains('is due') ||
        lower.contains('min amount due') ||
        lower.contains('minimum amount due') ||
        lower.contains('in arrears') ||
        lower.contains('is overdue') ||
        lower.contains('ignore if paid') ||
        (lower.contains('pls pay') && lower.contains('min of'))) {
      return false;
    }

    // Must contain transaction keywords
    const transactionKeywords = [
      'debited', 'credited', 'withdrawn', 'deposited',
      'spent', 'received', 'transferred', 'paid',
    ];

    return transactionKeywords.any((kw) => lower.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // fun extractCurrency(message): String?
  // ---------------------------------------------------------------------------

  /// Extracts the transaction currency from the message.
  String? extractCurrency(String message) {
    final currencyPattern =
        RegExp(r'([A-Z]{3})\s*[0-9,]+(?:\.\d{2})?', caseSensitive: false);
    final match = currencyPattern.firstMatch(message);
    if (match != null) return match.group(1)!.toUpperCase();
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun extractAmount(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  /// Extracts the transaction amount from the message.
  double? extractAmount(String message) {
    for (final pattern in CompiledPatterns.amount.allPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(amountStr);
        if (value != null) return value;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun extractTransactionType(message): TransactionType?
  // ---------------------------------------------------------------------------

  /// Extracts the transaction type (INCOME/EXPENSE/INVESTMENT).
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();

    if (isInvestmentTransaction(lower)) return TransactionType.investment;

    if (lower.contains('debited')) return TransactionType.expense;
    if (lower.contains('withdrawn')) return TransactionType.expense;
    if (lower.contains('spent')) return TransactionType.expense;
    if (lower.contains('charged')) return TransactionType.expense;
    if (lower.contains('paid')) return TransactionType.expense;
    if (lower.contains('purchase')) return TransactionType.expense;
    if (lower.contains('deducted')) return TransactionType.expense;

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
  // fun isInvestmentTransaction(lowerMessage): Boolean
  // ---------------------------------------------------------------------------

  /// Checks if the message is for an investment transaction.
  bool isInvestmentTransaction(String lowerMessage) {
    const investmentKeywords = [
      // Clearing corporations
      'iccl', 'indian clearing corporation', 'nsccl', 'nse clearing',
      'clearing corporation',
      // Auto-pay indicators
      'nach', 'ach', 'ecs',
      // Investment platforms
      'groww', 'zerodha', 'upstox', 'kite', 'kuvera', 'paytm money',
      'etmoney', 'coin by zerodha', 'smallcase', 'angel one',
      'angel broking', '5paisa', 'icici securities', 'icici direct',
      'hdfc securities', 'kotak securities', 'motilal oswal', 'sharekhan',
      'edelweiss', 'axis direct', 'sbi securities',
      // Investment types
      'mutual fund', 'sip', 'elss', 'ipo', 'folio', 'demat',
      'stockbroker', 'digital gold', 'sovereign gold',
      // Stock exchanges
      'nse', 'bse', 'cdsl', 'nsdl',
    ];

    return investmentKeywords.any((kw) => lowerMessage.contains(kw));
  }

  // ---------------------------------------------------------------------------
  // fun extractMerchant(message, sender): String?
  // ---------------------------------------------------------------------------

  /// Extracts merchant/payee information.
  String? extractMerchant(String message, String sender) {
    for (final pattern in CompiledPatterns.merchant.allPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final name = cleanMerchantName(match.group(1)!.trim());
        if (isValidMerchantName(name)) return name;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun extractReference(message): String?
  // ---------------------------------------------------------------------------

  /// Extracts transaction reference number.
  String? extractReference(String message) {
    for (final pattern in CompiledPatterns.reference.allPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) return match.group(1)!.trim();
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun extractLast4Digits(raw): String?
  // ---------------------------------------------------------------------------

  /// Extracts last 4 digits from a raw captured string.
  /// Filters to digits only, takes last 4. Returns null if fewer than 3 digits.
  String? extractLast4Digits(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
    return last4.length >= 3 ? last4 : null;
  }

  // ---------------------------------------------------------------------------
  // fun extractAccountLast4(message): String?
  // ---------------------------------------------------------------------------

  /// Extracts last 4 digits of account number.
  String? extractAccountLast4(String message) {
    for (final pattern in CompiledPatterns.account.allPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final rawCapture = match.group(1)!;
        final last4 = extractLast4Digits(rawCapture);
        if (last4 != null && _isValidAccountLast4(last4, match.group(0)!, message)) {
          return last4;
        }
      }
    }
    return null;
  }

  /// Validates that the extracted 4 digits are actually part of an account
  /// number, not a date, RRN, or other numeric field.
  bool _isValidAccountLast4(String last4, String matchedText, String fullMessage) {
    final escaped = RegExp.escape(last4);

    // Check if it's part of a date pattern (dd/mm/yyyy, dd-mm-yyyy, etc.)
    final datePatterns = [
      RegExp(r'\d{1,2}[/-]\d{1,2}[/-]' + escaped),
      RegExp(escaped + r'[/-]\d{1,2}[/-]\d{1,2}'),
      RegExp(r'\bon\s+\d{1,2}[/-]\d{1,2}[/-]' + escaped, caseSensitive: false),
      RegExp(r'\bdated\s+\d{1,2}[/-]\d{1,2}[/-]' + escaped, caseSensitive: false),
    ];

    for (final dp in datePatterns) {
      if (dp.hasMatch(fullMessage)) return false;
    }

    // Check if it's a standalone year (2024, 2025, etc.)
    final asInt = int.tryParse(last4);
    if (asInt != null && asInt >= 2000 && asInt <= 2099) {
      final yearContextPatterns = [
        RegExp(r'\bon\s+\d{1,2}[/-]\d{1,2}[/-]' + escaped, caseSensitive: false),
        RegExp(r'\bdated\s+.*?' + escaped, caseSensitive: false),
        RegExp(escaped + r'(?:\s|$)'),
      ];

      for (final yp in yearContextPatterns) {
        if (yp.hasMatch(fullMessage)) {
          final accountBeforeYear = RegExp(
            r'(?:A/c|Account|Acct).{0,25}' + escaped,
            caseSensitive: false,
          );
          if (!accountBeforeYear.hasMatch(fullMessage)) return false;
        }
      }
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // fun extractBalance(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  /// Extracts balance after transaction.
  double? extractBalance(String message) {
    for (final pattern in CompiledPatterns.balance.allPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final balStr = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(balStr);
        if (value != null) return value;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun extractAvailableLimit(message): BigDecimal?  →  double?
  // ---------------------------------------------------------------------------

  /// Extracts credit card available limit from the message.
  double? extractAvailableLimit(String message) {
    const cur = r'(?:Rs\.?|INR|₹)';
    final creditLimitPatterns = [
      RegExp(r'Available\s+limit\s+' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
      RegExp(r'Available\s+limit:?\s*' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
      RegExp(r'Avl\s+Lmt:?\s*' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
      RegExp(r'Avail\s+Limit:?\s*' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
      RegExp(r'Available\s+Credit\s+Limit:?\s*' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
      RegExp(r'(?:^|\s)Limit:?\s*' + cur + r'\s*([0-9,]+(?:\.\d{2})?)',
          caseSensitive: false),
    ];

    for (final pattern in creditLimitPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final limitStr = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(limitStr);
        if (value != null) return value;
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // fun detectIsCard(message): Boolean
  // ---------------------------------------------------------------------------

  /// Detects if the transaction is from a card (credit/debit).
  bool detectIsCard(String message) {
    final lower = message.toLowerCase();

    // FIRST: Explicitly exclude account-related patterns
    const accountPatterns = [
      'a/c', 'account', 'ac ', 'acc ',
      'saving account', 'current account', 'savings a/c', 'current a/c',
    ];

    for (final p in accountPatterns) {
      if (lower.contains(p)) return false;
    }

    // SECOND: Check for actual card-specific patterns
    const cardPatterns = [
      'card ending', 'card xx', 'debit card', 'credit card',
      'card no.', 'card number', 'card *', 'card x',
    ];

    for (final p in cardPatterns) {
      if (lower.contains(p)) return true;
    }

    // Check for masked card number patterns
    final maskedCardRegex = RegExp(r'(?:xx|XX|\*{2,})?\d{4}');
    if (lower.contains('ending') && maskedCardRegex.hasMatch(message)) {
      return true;
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  // fun cleanMerchantName(merchant): String
  // ---------------------------------------------------------------------------

  /// Cleans merchant name by removing common suffixes and noise.
  /// Uses CompiledPatterns.Cleaning in the exact Kotlin source order.
  String cleanMerchantName(String merchant) {
    return merchant
        .replaceAll(CompiledPatterns.cleaning.trailingParentheses, '')
        .replaceAll(CompiledPatterns.cleaning.refNumberSuffix, '')
        .replaceAll(CompiledPatterns.cleaning.dateSuffix, '')
        .replaceAll(CompiledPatterns.cleaning.upiSuffix, '')
        .replaceAll(CompiledPatterns.cleaning.timeSuffix, '')
        .replaceAll(CompiledPatterns.cleaning.trailingDash, '')
        .replaceAll(CompiledPatterns.cleaning.pvtLtd, '')
        .replaceAll(CompiledPatterns.cleaning.ltd, '')
        .trim();
  }

  // ---------------------------------------------------------------------------
  // fun isValidMerchantName(name): Boolean
  // ---------------------------------------------------------------------------

  /// Validates if the extracted merchant name is valid.
  bool isValidMerchantName(String name) {
    const commonWords = {
      'USING', 'VIA', 'THROUGH', 'BY', 'WITH', 'FOR', 'TO', 'FROM', 'AT', 'THE',
    };

    return name.length >= ParserConstants.minMerchantNameLength &&
        name.split('').any((c) => RegExp(r'[a-zA-Z]').hasMatch(c)) &&
        !commonWords.contains(name.toUpperCase()) &&
        !RegExp(r'^\d+$').hasMatch(name) &&
        !name.contains('@');
  }
}
