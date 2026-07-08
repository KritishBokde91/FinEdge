/// DLT (Distributed Ledger Technology) sender filtering for Indian financial SMS.
///
/// Indian SMS senders follow DLT format: XX-BANKID or XX-BANKID-S/-T/-P/-G
///   -P = Promotional (discard)
///   -G = Government (discard)
///   -T = Transactional (process)
///   -S = Service (process)
class SenderFilter {
  /// Returns true if this sender looks like a financial/transactional sender.
  static bool isFinancialSender(String sender) {
    if (sender.isEmpty) return false;
    final upper = sender.toUpperCase().trim();

    // Numeric senders (short codes) – could be bank
    if (RegExp(r'^\d{5,}$').hasMatch(upper)) return true;

    // Discard promotional and government DLT senders
    if (upper.endsWith('-P') || upper.endsWith('-G')) return false;

    // Known bank sender patterns (case insensitive)
    if (_isKnownBankSender(upper)) return true;

    // DLT format transactional (-T) and service (-S) suffixes
    if (upper.endsWith('-T') || upper.endsWith('-S')) return true;

    // Generic DLT format: 2 letter prefix + hyphen + alphanumeric
    if (RegExp(r'^[A-Z]{2}-[A-Z]{2,}').hasMatch(upper)) return true;

    // Contains known bank abbreviations anywhere
    if (_containsBankKeyword(upper)) return true;

    return false;
  }

  static bool _isKnownBankSender(String upper) {
    // Major Indian banks and fintech senders
    const bankPatterns = [
      'HDFCBK', 'HDFCBANK', 'HDFC', 'HDFCB',
      'SBIBNK', 'SBIBK', 'SBIINB', 'SBIUPI', 'SBICRD', 'ATMSBI', 'SBI',
      'ICICIB', 'ICICI', 'ICICIBANK',
      'AXISBK', 'AXISBANK', 'AXIS',
      'KOTAKB', 'KOTAK',
      'BOBANK', 'BOBBNK', 'BOB',
      'PNBANK', 'PNBBNK', 'PNB',
      'CANBNK', 'CANARA',
      'UNIONB', 'UNIONBANK',
      'IDFCFB', 'IDFC',
      'YESBK', 'YESBANK',
      'INDUSB', 'INDUSIND',
      'FEDSBNK', 'FEDERAL',
      'RBLBNK', 'RBL',
      'SCBANK', 'STANC',
      'CITIBK', 'CITI',
      'AMEXIN', 'AMEX',
      'DBIBNK', 'DBS',
      'HSBCBK', 'HSBC',
      'BARODBK', 'BARODA',
      'IOBBNK', 'IOB',
      'CENTBK', 'CENTRAL',
      'MAHABK', 'MAHA',
      'BANDHAN', 'BANDHNBK',
      'AUSFIN', 'AUBANK',
      'IDBIBNK', 'IDBI',
      'PAYTMB', 'PAYTM',
      'PHONPE', 'PHONEPE',
      'GPAY', 'GOOGLEPAY',
      'AMAZONPAY', 'APAY',
      'BHARPE', 'BHIM',
      'MOBIKWK', 'MOBIKWIK',
      'FREECHARGE', 'FREECHRG',
      'BAJFIN', 'BAJAJ',
      'TATACAP', 'TATA',
      'LICIND', 'LIC',
      'MPESA', 'M-PESA',
      'JIOBNK', 'JIO',
      'AIRNTEL', 'AIRTEL',
      'SLCFIN', 'SLICE',
      'SIMPL',
      'LAZYPAY',
      'CRED',
      'JUPITER',
      'FI-MONEY',
      'NIYO',
    ];

    for (final pattern in bankPatterns) {
      if (upper.contains(pattern)) return true;
    }

    // DLT regex patterns for major banks
    final dltPatterns = [
      RegExp(r'^[A-Z]{2}-HDFC'),
      RegExp(r'^[A-Z]{2}-SBI'),
      RegExp(r'^[A-Z]{2}-ICICI'),
      RegExp(r'^[A-Z]{2}-AXIS'),
      RegExp(r'^[A-Z]{2}-KOTAK'),
      RegExp(r'^[A-Z]{2}-PNB'),
      RegExp(r'^[A-Z]{2}-BOB'),
      RegExp(r'^[A-Z]{2}-CANBNK'),
      RegExp(r'^[A-Z]{2}-UNION'),
      RegExp(r'^[A-Z]{2}-IDFC'),
      RegExp(r'^[A-Z]{2}-YES'),
      RegExp(r'^[A-Z]{2}-INDUS'),
      RegExp(r'^[A-Z]{2}-FED'),
      RegExp(r'^[A-Z]{2}-RBL'),
      RegExp(r'^[A-Z]{2}-CITI'),
      RegExp(r'^[A-Z]{2}-HSBC'),
      RegExp(r'^[A-Z]{2}-AMEX'),
      RegExp(r'^[A-Z]{2}-STANC'),
      RegExp(r'^[A-Z]{2}-BARODA'),
      RegExp(r'^[A-Z]{2}-IOB'),
      RegExp(r'^[A-Z]{2}-PAYTM'),
      RegExp(r'^[A-Z]{2}-BAJFIN'),
      RegExp(r'^[A-Z]{2}-BANDHN'),
      RegExp(r'^[A-Z]{2}-AUSFIN'),
      RegExp(r'^[A-Z]{2}-IDBI'),
      RegExp(r'^HDFC-'),
      RegExp(r'^SBI-'),
      RegExp(r'^ICICI-'),
    ];

    for (final rx in dltPatterns) {
      if (rx.hasMatch(upper)) return true;
    }

    return false;
  }

  static bool _containsBankKeyword(String upper) {
    // Generic banking keywords that could indicate financial sender
    const keywords = [
      'BANK',
      'CREDIT',
      'DEBIT',
      'LOAN',
      'MUTUAL',
      'INSUR',
      'WALLET',
    ];
    for (final kw in keywords) {
      if (upper.contains(kw)) return true;
    }
    return false;
  }

  /// Extract bank name from sender address.
  static String detectBank(String sender) {
    final upper = sender.toUpperCase().trim();

    // Remove DLT prefix (XX-) and suffix (-T/-S) for cleaner matching
    String cleaned = upper;
    if (RegExp(r'^[A-Z]{2}-').hasMatch(cleaned)) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('-T') || cleaned.endsWith('-S')) {
      cleaned = cleaned.substring(0, cleaned.length - 2);
    }

    if (cleaned.contains('HDFC')) return 'HDFC Bank';
    if (cleaned.contains('SBI') || cleaned.contains('SBIBK')) {
      return 'State Bank of India';
    }
    if (cleaned.contains('ICICI')) return 'ICICI Bank';
    if (cleaned.contains('AXIS')) return 'Axis Bank';
    if (cleaned.contains('KOTAK')) return 'Kotak Mahindra Bank';
    if (cleaned.contains('BOB') || cleaned.contains('BARODA')) {
      return 'Bank of Baroda';
    }
    if (cleaned.contains('PNB')) return 'Punjab National Bank';
    if (cleaned.contains('CANBNK') || cleaned.contains('CANARA')) {
      return 'Canara Bank';
    }
    if (cleaned.contains('UNION')) return 'Union Bank';
    if (cleaned.contains('IDFC')) return 'IDFC First Bank';
    if (cleaned.contains('YES')) return 'Yes Bank';
    if (cleaned.contains('INDUS')) return 'IndusInd Bank';
    if (cleaned.contains('FED')) return 'Federal Bank';
    if (cleaned.contains('RBL')) return 'RBL Bank';
    if (cleaned.contains('CITI')) return 'Citibank';
    if (cleaned.contains('HSBC')) return 'HSBC';
    if (cleaned.contains('STANC') || cleaned.contains('SCBANK')) {
      return 'Standard Chartered';
    }
    if (cleaned.contains('AMEX')) return 'American Express';
    if (cleaned.contains('DBS')) return 'DBS Bank';
    if (cleaned.contains('IOB')) return 'Indian Overseas Bank';
    if (cleaned.contains('CENTRAL') || cleaned.contains('CENTBK')) {
      return 'Central Bank of India';
    }
    if (cleaned.contains('MAHA')) return 'Bank of Maharashtra';
    if (cleaned.contains('BANDHAN') || cleaned.contains('BANDHN')) {
      return 'Bandhan Bank';
    }
    if (cleaned.contains('AUSFIN') || cleaned.contains('AUBANK')) {
      return 'AU Small Finance Bank';
    }
    if (cleaned.contains('IDBI')) return 'IDBI Bank';
    if (cleaned.contains('PAYTM')) return 'Paytm Payments Bank';
    if (cleaned.contains('PHONPE') || cleaned.contains('PHONEPE')) {
      return 'PhonePe';
    }
    if (cleaned.contains('GPAY') || cleaned.contains('GOOGLEPAY')) {
      return 'Google Pay';
    }
    if (cleaned.contains('MPESA') || cleaned.contains('M-PESA')) {
      return 'M-Pesa';
    }
    if (cleaned.contains('BAJFIN') || cleaned.contains('BAJAJ')) {
      return 'Bajaj Finserv';
    }
    if (cleaned.contains('LIC')) return 'LIC';
    if (cleaned.contains('SLICE') || cleaned.contains('SLCFIN')) return 'Slice';
    if (cleaned.contains('CRED')) return 'CRED';
    if (cleaned.contains('JUPITER')) return 'Jupiter';
    if (cleaned.contains('NIYO')) return 'Niyo';
    if (cleaned.contains('JIO')) return 'Jio Payments Bank';
    if (cleaned.contains('AIRTEL')) return 'Airtel Payments Bank';

    return 'Unknown Bank';
  }
}
