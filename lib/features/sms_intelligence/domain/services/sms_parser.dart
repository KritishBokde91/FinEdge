import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser_factory.dart';
import 'sender_filter.dart';

/// Production-grade SMS parser modeled after PennyWise's proven parsing engine.
/// Supports Indian banks (primary), Kenyan banks, and generic financial SMS.
class SmsParseResult {
  final String? merchant;
  final double amount;
  final String currency;
  final String? bank;
  final String? account;
  final String transactionType; // 'debit', 'credit', 'unknown'
  final String? referenceNumber;
  final String? upiId;
  final double? availableBalance;
  final String paymentMethod;
  final String transactionStatus; // 'success', 'failed', 'pending', 'reversed'
  final String category;
  final double confidence;
  final bool isFromCard;

  const SmsParseResult({
    this.merchant,
    required this.amount,
    this.currency = 'INR',
    this.bank,
    this.account,
    required this.transactionType,
    this.referenceNumber,
    this.upiId,
    this.availableBalance,
    this.paymentMethod = 'Unknown',
    this.transactionStatus = 'success',
    this.category = 'Other',
    this.confidence = 0.0,
    this.isFromCard = false,
  });
}

class SmsParser {
  // ── Content Filters (PennyWise-style) ──────────────────────────

  /// Returns true if this SMS body looks like a real transaction.
  /// Filters OUT: OTPs, promotional, payment requests, reminders.
  static bool isTransactionMessage(String body) {
    final lower = body.toLowerCase();

    // Skip OTP messages
    if (_isOtpMessage(lower)) return false;

    // Skip promotional messages
    if (_isPromotionalMessage(lower)) return false;

    // Skip payment requests / collect requests
    if (_isPaymentRequest(lower)) return false;

    // Must contain at least one transaction keyword
    return _hasTransactionKeyword(lower);
  }

  static bool _isOtpMessage(String lower) {
    return lower.contains('otp') ||
        lower.contains('one time password') ||
        lower.contains('verification code') ||
        lower.contains('one-time password') ||
        lower.contains('secure code') ||
        lower.contains('login code') ||
        lower.contains('authentication code');
  }

  static bool _isPromotionalMessage(String lower) {
    // Must have BOTH promotional keywords AND lack transaction keywords
    const promoKeywords = [
      'offer',
      'discount',
      'cashback offer',
      'reward points',
      'pre-approved',
      'preapproved',
      'apply now',
      'limited period',
      'congratulations! you',
      'you are eligible',
      'special offer',
      'win ',
      'prize',
      'free ',
      'click here',
      'bit.ly',
      'http',
    ];

    final hasPromo = promoKeywords.any((k) => lower.contains(k));
    if (!hasPromo) return false;

    // If it also has clear transaction markers, it's NOT promo
    const txKeywords = [
      'debited',
      'credited',
      'withdrawn',
      'deposited',
      'transferred',
    ];
    return !txKeywords.any((k) => lower.contains(k));
  }

  static bool _isPaymentRequest(String lower) {
    return lower.contains('has requested') ||
        lower.contains('collect request') ||
        lower.contains('payment request') ||
        lower.contains('pay request') ||
        (lower.contains('mandate') && !lower.contains('debited'));
  }

  static bool _hasTransactionKeyword(String lower) {
    const keywords = [
      'debited', 'credited', 'withdrawn', 'deposited',
      'spent', 'received', 'transferred', 'paid',
      'sent', 'refund', 'purchase', 'payment',
      'transaction', 'txn', 'debit', 'credit',
      'deducted', 'charged', 'reversed',
      'salary', 'cashback',
    ];
    return keywords.any((k) => lower.contains(k));
  }

  // ── Main Parse Method ──────────────────────────────────────────

  static SmsParseResult parseMessage(String sender, String body) {
    // 1. Try bank-specific parsers from BankParserFactory first
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final parsedTx = BankParserFactory.parse(body, sender, timestamp);

    if (parsedTx != null) {
      String txType = 'unknown';
      switch (parsedTx.type) {
        case TransactionType.income:
          txType = 'credit';
          break;
        case TransactionType.expense:
        case TransactionType.credit:
        case TransactionType.transfer:
        case TransactionType.investment:
          txType = 'debit';
          break;
        case TransactionType.balanceUpdate:
          txType = 'unknown';
          break;
      }

      final lowerBody = body.toLowerCase();
      final paymentMethod = _detectPaymentMethod(lowerBody);
      final category = _classifyCategory(parsedTx.merchant, lowerBody);

      // Score confidence
      double confidence = 0.7; // default base for pattern-based native parsing
      if (parsedTx.merchant != null) confidence += 0.15;
      if (parsedTx.reference != null) confidence += 0.1;
      if (parsedTx.balance != null) confidence += 0.05;
      confidence = confidence.clamp(0.0, 1.0);

      return SmsParseResult(
        merchant: parsedTx.merchant,
        amount: parsedTx.amount,
        currency: parsedTx.currency,
        bank: parsedTx.bankName,
        account: parsedTx.accountLast4,
        transactionType: txType,
        referenceNumber: parsedTx.reference,
        upiId: _extractUpiId(body),
        availableBalance: parsedTx.balance,
        paymentMethod: paymentMethod,
        transactionStatus: 'success',
        category: category,
        confidence: confidence,
        isFromCard: parsedTx.isFromCard,
      );
    }

    // 2. Original Fallback generic parsing logic
    // Normalize: keep original for display but work with cleaned version
    final cleaned = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    final lower = cleaned.toLowerCase();

    final transactionType = _detectTransactionType(lower);
    final status = _detectStatus(lower);
    final amount = _extractAmount(cleaned);
    final balance = _extractBalance(cleaned);
    final account = _extractAccount(cleaned);
    final reference = _extractReference(cleaned);
    final upiId = _extractUpiId(cleaned);
    final paymentMethod = _detectPaymentMethod(lower);
    final isFromCard = _detectIsCard(lower);
    final bank = SenderFilter.detectBank(sender);
    final merchant = _extractMerchant(cleaned, transactionType);
    final category = _classifyCategory(merchant, lower);

    // Confidence scoring (PennyWise-style)
    double confidence = 0.0;
    if (amount > 0) confidence += 0.3;
    if (transactionType != 'unknown') confidence += 0.25;
    if (account != null) confidence += 0.15;
    if (merchant != null) confidence += 0.15;
    if (reference != null) confidence += 0.1;
    if (balance != null) confidence += 0.05;
    confidence = confidence.clamp(0.0, 1.0);

    return SmsParseResult(
      merchant: merchant,
      amount: amount,
      currency: _detectCurrency(cleaned),
      bank: bank != 'Unknown Bank' ? bank : null,
      account: account,
      transactionType: transactionType,
      referenceNumber: reference,
      upiId: upiId,
      availableBalance: balance,
      paymentMethod: paymentMethod,
      transactionStatus: status,
      category: category,
      confidence: confidence,
      isFromCard: isFromCard,
    );
  }

  // ── Transaction Type Detection ─────────────────────────────────

  static String _detectTransactionType(String lower) {
    // Debit indicators (PennyWise: EXPENSE type)
    const debitKeywords = [
      'debited', 'deducted', 'spent', 'paid', 'sent',
      'withdrawn', 'purchase', 'charged', 'payment of',
      'transferred from', 'debit',
    ];

    // Credit indicators (PennyWise: INCOME/CREDIT type)
    const creditKeywords = [
      'credited', 'received', 'deposited', 'refund',
      'reversed', 'cashback', 'salary', 'credit',
    ];

    // Check debit first (more common)
    for (final kw in debitKeywords) {
      if (lower.contains(kw)) return 'debit';
    }

    for (final kw in creditKeywords) {
      if (lower.contains(kw)) return 'credit';
    }

    return 'unknown';
  }

  // ── Amount Extraction ──────────────────────────────────────────

  static double _extractAmount(String text) {
    // Multiple patterns in priority order (PennyWise CompiledPatterns style)
    final patterns = [
      // INR patterns: Rs., Rs, INR, ₹
      RegExp(
        r'(?:Rs\.?|INR|₹)\s*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      // Amount with context: "of Rs 1234" / "for Rs 1234"
      RegExp(
        r'(?:of|for|amount|amt|rs|inr)\s*:?\s*(?:Rs\.?|INR|₹)?\s*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      // Kenyan: Ksh
      RegExp(
        r'(?:Ksh|KES)\s*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      // Generic amount after keywords
      RegExp(
        r'(?:debited|credited|sent|received|paid|spent|withdrawn|deposited|transferred|charged|deducted)\s+(?:(?:with|by|for|of|from|to|rs\.?|inr|₹)\s*)*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(raw);
        if (value != null && value > 0 && value < 100000000) {
          return value;
        }
      }
    }
    return 0.0;
  }

  // ── Balance Extraction ─────────────────────────────────────────

  static double? _extractBalance(String text) {
    final patterns = [
      RegExp(
        r'(?:Avl\s*Bal|Available\s*Balance|Bal|Balance|Avl\.?\s*Bal\.?|A/c\s*bal)[:\s]*(?:Rs\.?|INR|₹|Ksh)?\s*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:bal\.?\s*(?:is)?)[:\s]*(?:Rs\.?|INR|₹)?\s*([0-9,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)!.replaceAll(',', '');
        final value = double.tryParse(raw);
        if (value != null && value >= 0) return value;
      }
    }
    return null;
  }

  // ── Account Extraction ─────────────────────────────────────────

  static String? _extractAccount(String text) {
    final patterns = [
      // "A/c XX1234" or "Account ending 1234"
      RegExp(
        r'(?:A/?c|Account|Acct)\.?\s*(?:no\.?\s*)?(?:ending\s+)?[:\s]*(?:\*+|X+|x+)?(\d{3,4})',
        caseSensitive: false,
      ),
      // "Card ending 1234"
      RegExp(
        r'(?:Card|Debit Card|Credit Card)\s+(?:no\.?\s*)?(?:ending\s+)?[:\s]*(?:\*+|X+|x+)?(\d{3,4})',
        caseSensitive: false,
      ),
      // "ending 1234" / "ending with 1234"
      RegExp(
        r'ending\s+(?:with\s+)?(?:\*+|X+|x+)?(\d{3,4})',
        caseSensitive: false,
      ),
      // "XXXX1234" pattern (masked account)
      RegExp(r'(?:XX|xx|\*\*)\d*(\d{4})', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final digits = match.group(1)!;
        // Extract last 4 digits
        if (digits.length >= 4) return digits.substring(digits.length - 4);
        return digits;
      }
    }
    return null;
  }

  // ── Reference Extraction ───────────────────────────────────────

  static String? _extractReference(String text) {
    // M-Pesa format starts with 8-12 alphanumeric characters followed by space
    final mpesaMatch = RegExp(r'^([A-Z0-9]{8,12})\s').firstMatch(text);
    if (mpesaMatch != null) {
      return mpesaMatch.group(1);
    }

    final patterns = [
      RegExp(
        r'(?:Ref\.?\s*(?:No\.?\s*)?|Txn\s*(?:No\.?\s*)?|Transaction\s*(?:ID|No\.?\s*)?|UPI\s*(?:Ref|ID)|UTR\s*(?:No\.?\s*)?|IMPS\s*(?:Ref)?|NEFT\s*(?:Ref)?)[:\s]*([A-Za-z0-9]+)',
        caseSensitive: false,
      ),
      // Standalone UPI reference
      RegExp(r'UPI[:\s]*(\d{12,})', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) return match.group(1);
    }
    return null;
  }

  // ── UPI ID Extraction ──────────────────────────────────────────

  static String? _extractUpiId(String text) {
    final match =
        RegExp(r'([a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+)').firstMatch(text);
    if (match != null) {
      final id = match.group(1)!;
      // Validate it looks like UPI, not email
      const upiHandles = [
        'upi', 'paytm', 'ybl', 'oksbi', 'okaxis', 'okicici',
        'okhdfcbank', 'ibl', 'apl', 'axl', 'sbi', 'icici', 'hdfcbank',
        'axisbank', 'kotak', 'indus', 'federal', 'rbl', 'bob', 'pnb',
        'cnrb', 'union', 'dbs', 'hsbc', 'citi', 'sc', 'idfc',
        'freecharge', 'mobikwik', 'amazonpay', 'gpay', 'phonepe',
        'slice', 'jupiter', 'fi', 'cred', 'niyo', 'jio', 'airtel',
      ];
      final handle = id.split('@').last.toLowerCase();
      if (upiHandles.contains(handle)) return id;
    }
    return null;
  }

  // ── Payment Method Detection ───────────────────────────────────

  static String _detectPaymentMethod(String lower) {
    if (lower.contains('upi') ||
        lower.contains('gpay') ||
        lower.contains('phonepe') ||
        lower.contains('paytm') ||
        lower.contains('bhim')) {
      return 'UPI';
    }
    if (lower.contains('neft')) {
      return 'NEFT';
    }
    if (lower.contains('imps')) {
      return 'IMPS';
    }
    if (lower.contains('rtgs')) {
      return 'RTGS';
    }
    if (lower.contains('nach') ||
        lower.contains('mandate') ||
        lower.contains('auto debit') ||
        lower.contains('ecs')) {
      return 'NACH';
    }
    if (lower.contains('atm') || lower.contains('cash withdrawal')) {
      return 'ATM';
    }
    if (lower.contains('pos') || lower.contains('swipe')) {
      return 'POS';
    }
    if (lower.contains('netbanking') ||
        lower.contains('net banking') ||
        lower.contains('online')) {
      return 'Net Banking';
    }
    if (lower.contains('card') ||
        lower.contains('visa') ||
        lower.contains('mastercard') ||
        lower.contains('rupay') ||
        lower.contains('amex')) {
      return 'Card';
    }
    if (lower.contains('cheque') || lower.contains('check')) {
      return 'Cheque';
    }
    return 'Unknown';
  }

  // ── Card Detection ─────────────────────────────────────────────

  static bool _detectIsCard(String lower) {
    return lower.contains('card') ||
        lower.contains('visa') ||
        lower.contains('mastercard') ||
        lower.contains('rupay') ||
        lower.contains('credit card') ||
        lower.contains('debit card');
  }

  // ── Status Detection ───────────────────────────────────────────

  static String _detectStatus(String lower) {
    if (lower.contains('failed') ||
        lower.contains('failure') ||
        lower.contains('declined') ||
        lower.contains('unsuccessful') ||
        lower.contains('could not') ||
        lower.contains('not processed')) {
      return 'failed';
    }
    if (lower.contains('pending') ||
        lower.contains('processing') ||
        lower.contains('in progress')) {
      return 'pending';
    }
    if (lower.contains('reversed') || lower.contains('reversal')) {
      return 'reversed';
    }
    return 'success';
  }

  // ── Currency Detection ─────────────────────────────────────────

  static String _detectCurrency(String text) {
    if (RegExp(r'(?:Rs\.?|INR|₹)', caseSensitive: false).hasMatch(text)) {
      return 'INR';
    }
    if (RegExp(r'(?:Ksh|KES)', caseSensitive: false).hasMatch(text)) {
      return 'Ksh';
    }
    if (RegExp(r'(?:USD|\$)', caseSensitive: false).hasMatch(text)) {
      return 'USD';
    }
    return 'INR'; // Default for Indian context
  }

  // ── Merchant Extraction ────────────────────────────────────────

  static String? _extractMerchant(String text, String txType) {
    // Try known merchant aliases first
    final alias = _matchKnownMerchant(text.toLowerCase());
    if (alias != null) return alias;

    // Pattern-based extraction (PennyWise CompiledPatterns style)
    final patterns = [
      // "to [merchant]" pattern
      RegExp(
        r'(?:to|paid to|transferred to|sent to)\s+([A-Za-z][A-Za-z0-9\s&.\-]+?)(?:\s+(?:on|at|Ref|UPI|via|for|Rs|INR|₹|w\.e\.f|A/c|Account|ending|VPA|ref|Txn|$))',
        caseSensitive: false,
      ),
      // "at [merchant]" pattern
      RegExp(
        r'(?:at)\s+([A-Za-z][A-Za-z0-9\s&.\-]+?)(?:\s+(?:on|Ref|UPI|via|for|Rs|INR|₹|$))',
        caseSensitive: false,
      ),
      // "from [merchant]" (for credits)
      RegExp(
        r'(?:from|received from|credited by)\s+([A-Za-z][A-Za-z0-9\s&.\-]+?)(?:\s+(?:on|Ref|UPI|via|for|Rs|INR|₹|to|$))',
        caseSensitive: false,
      ),
      // "for [purpose]" pattern
      RegExp(
        r'(?:for)\s+([A-Za-z][A-Za-z0-9\s&.\-]+?)(?:\s+(?:on|Ref|UPI|via|Rs|INR|₹|$))',
        caseSensitive: false,
      ),
      // VPA / UPI ID as merchant fallback
      RegExp(
        r'VPA\s+([a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        String merchant = match.group(1)!.trim();
        merchant = _cleanMerchantName(merchant);
        if (merchant.length >= 2 && merchant.length <= 60) {
          return merchant;
        }
      }
    }
    return null;
  }

  static String _cleanMerchantName(String name) {
    // Remove trailing reference/date/UPI patterns
    name = name
        .replaceAll(
          RegExp(
            r'\s*(?:PVT|LTD|PRIVATE|LIMITED|INDIA)\.?\s*$',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
    name =
        name.replaceAll(RegExp(r'\s*\d{2}/\d{2}/\d{2,4}\s*$'), '').trim();
    name = name
        .replaceAll(RegExp(r'\s*ref.*$', caseSensitive: false), '')
        .trim();
    name = name
        .replaceAll(RegExp(r'\s*txn.*$', caseSensitive: false), '')
        .trim();
    // Remove trailing dots, hyphens, and whitespace
    name = name.replaceAll(RegExp(r'[.\s\-_]+$'), '').trim();
    // Capitalize words
    return name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  static String? _matchKnownMerchant(String lower) {
    final merchantPatterns = {
      'Amazon': RegExp(r'\b(amazon|amzn)\b'),
      'Flipkart': RegExp(r'\bflipkart\b'),
      'Myntra': RegExp(r'\bmyntra\b'),
      'AJIO': RegExp(r'\bajio\b'),
      'Swiggy': RegExp(r'\bswiggy\b'),
      'Zomato': RegExp(r'\bzomato\b'),
      'Uber': RegExp(r'\buber\b'),
      'Ola': RegExp(r'\bola\b'),
      'Rapido': RegExp(r'\brapido\b'),
      'Netflix': RegExp(r'\bnetflix\b'),
      'Spotify': RegExp(r'\bspotify\b'),
      'Hotstar': RegExp(r'\bhotstar\b'),
      'Amazon Prime Video': RegExp(r'\bprime video\b'),
      'YouTube Premium': RegExp(r'\byoutube premium\b'),
      'Google Play': RegExp(r'\bgoogle play\b'),
      'Apple': RegExp(r'\bapple\b'),
      'JioCinema': RegExp(r'\bjiocinema\b'),
      'Google Pay': RegExp(r'\bgpay\b'),
      'PhonePe': RegExp(r'\bphonepe\b'),
      'Paytm': RegExp(r'\bpaytm\b'),
      'CRED': RegExp(r'\bcred\b'),
      'BigBasket': RegExp(r'\bbigbasket\b'),
      'Blinkit': RegExp(r'\bblinkit\b'),
      'Zepto': RegExp(r'\bzepto\b'),
      'Swiggy Instamart': RegExp(r'\binstamart\b'),
      'Dunzo': RegExp(r'\bdunzo\b'),
      'JioMart': RegExp(r'\bjiomart\b'),
      'DMart': RegExp(r'\bdmart\b'),
      'Reliance': RegExp(r'\breliance\b'),
      'Tata CLiQ': RegExp(r'\btata cliq\b'),
      'Nykaa': RegExp(r'\bnykaa\b'),
      'Meesho': RegExp(r'\bmeesho\b'),
      'IRCTC': RegExp(r'\birctc\b'),
      'MakeMyTrip': RegExp(r'\b(makemytrip|mmt)\b'),
      'Goibibo': RegExp(r'\bgoibibo\b'),
      'Cleartrip': RegExp(r'\bcleartrip\b'),
      'Ixigo': RegExp(r'\bixigo\b'),
      'Booking.com': RegExp(r'\bbooking\.com\b'),
      'OYO': RegExp(r'\boyo\b'),
      'Airtel': RegExp(r'\bairtel\b'),
      'Jio': RegExp(r'\bjio\b'),
      'Vi': RegExp(r'\bvi\b'),
      'Vodafone': RegExp(r'\bvodafone\b'),
      'BSNL': RegExp(r'\bbsnl\b'),
      'Electricity Bill': RegExp(r'\belectricity\b'),
      'BESCOM': RegExp(r'\bbescom\b'),
      'MSEDCL': RegExp(r'\bmsedcl\b'),
      'Gas Bill': RegExp(r'\bgas bill\b'),
      'Water Bill': RegExp(r'\bwater bill\b'),
      'Bajaj Finserv': RegExp(r'\bbajaj finserv\b'),
      'Slice': RegExp(r'\bslice\b'),
      'Simpl': RegExp(r'\bsimpl\b'),
      'LazyPay': RegExp(r'\blazypay\b'),
      'Groww': RegExp(r'\bgroww\b'),
      'Zerodha': RegExp(r'\bzerodha\b'),
      'Upstox': RegExp(r'\bupstox\b'),
      'Mutual Fund': RegExp(r'\bmutual fund\b'),
      'LIC': RegExp(r'\blic\b'),
      'SIP Investment': RegExp(r'\bsip\b'),
      'Dream11': RegExp(r'\bdream11\b'),
      'Tata Neu': RegExp(r'\btataneu\b'),
      'Safaricom': RegExp(r'\bsafaricom\b'),
      'Kenya Power': RegExp(r'\b(kenya power|kplc)\b'),
    };

    for (final entry in merchantPatterns.entries) {
      if (entry.value.hasMatch(lower)) {
        return entry.key;
      }
    }
    return null;
  }


  // ── Category Classification ────────────────────────────────────

  static String _classifyCategory(String? merchant, String lower) {
    if (merchant != null) {
      final m = merchant.toLowerCase();

      // Food
      if ([
        'swiggy', 'zomato', 'restaurant', 'cafe', 'food', 'pizza', 'burger',
        'mcdonald', 'kfc', 'domino', 'starbucks', 'dunkin', 'haldiram',
        'barbeque', 'biryani',
      ].any((k) => m.contains(k))) {
        return 'Food';
      }

      // Groceries & Shopping & Health
      if ([
        'bigbasket', 'blinkit', 'zepto', 'instamart', 'dunzo', 'jiomart',
        'dmart', 'grofers', 'grocery', 'supermarket', 'reliance fresh',
        'more megastore', 'nature basket',
        'amazon', 'flipkart', 'myntra', 'ajio', 'meesho', 'nykaa',
        'tata cliq', 'shoppers stop', 'lifestyle', 'westside', 'h&m',
        'zara', 'decathlon',
        'pharmacy', 'pharma', 'medical', 'hospital', 'doctor', 'apollo',
        'medplus', 'netmeds', 'practo', '1mg', 'tata 1mg', 'healthians',
      ].any((k) => m.contains(k))) {
        return 'Shopping';
      }

      // Transport & Travel
      if ([
        'uber', 'ola', 'rapido', 'irctc', 'metro', 'petrol', 'diesel',
        'fuel', 'parking', 'toll', 'fastag',
        'makemytrip', 'goibibo', 'cleartrip', 'ixigo', 'booking.com',
        'oyo', 'hotel', 'flight', 'airline', 'indigo', 'spicejet',
        'air india', 'vistara',
      ].any((k) => m.contains(k))) {
        return 'Transport';
      }

      // Entertainment
      if ([
        'netflix', 'spotify', 'hotstar', 'prime video', 'youtube',
        'jiocinema', 'google play', 'apple', 'zee5', 'sonyliv', 'dream11',
        'movie', 'pvr', 'inox', 'bookmyshow',
      ].any((k) => m.contains(k))) {
        return 'Entertainment';
      }

      // Telecom & Recharge
      if ([
        'airtel', 'jio', 'vi ', 'vodafone', 'bsnl', 'recharge', 'prepaid',
        'postpaid',
      ].any((k) => m.contains(k))) {
        return 'Recharge';
      }

      // Bills, Utilities & Education
      if ([
        'electricity', 'power', 'kplc', 'bescom', 'msedcl', 'gas bill', 'water bill',
        'broadband', 'internet', 'wifi',
        'school', 'college', 'university', 'course', 'udemy', 'coursera',
        'unacademy', 'byju', 'tuition',
      ].any((k) => m.contains(k))) {
        return 'Bills';
      }

      // Investment, EMI & Loans
      if ([
        'groww', 'zerodha', 'upstox', 'mutual fund', 'sip', 'lic',
        'insurance', 'investment',
        'emi', 'loan', 'bajaj finserv', 'slice', 'simpl', 'lazypay',
        'cred',
      ].any((k) => m.contains(k))) {
        return 'Investment';
      }
    }

    // Fallback: keyword-based from SMS body
    if (lower.contains('salary') ||
        lower.contains('stipend') ||
        lower.contains('wage')) {
      return 'Salary';
    }
    if (lower.contains('rent') || lower.contains('lease')) {
      return 'Bills';
    }
    if (lower.contains('emi') ||
        lower.contains('loan') ||
        lower.contains('instalment')) {
      return 'Investment';
    }
    if (lower.contains('transfer') ||
        lower.contains('neft') ||
        lower.contains('imps') ||
        lower.contains('rtgs')) {
      return 'Investment';
    }
    if (lower.contains('atm') || lower.contains('cash')) {
      return 'Shopping';
    }
    if (lower.contains('refund') || lower.contains('reversal')) {
      return 'Salary';
    }

    return 'Other';
  }
}
