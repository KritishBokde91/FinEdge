/// Pre-compiled [RegExp] patterns for financial SMS parsing.
///
/// Direct port of `parser-core/CompiledPatterns.kt` (and the matching
/// `app/core/CompiledPatterns.kt`).  Every regex, every nested object, every
/// ALL_PATTERNS list, and every execution order is preserved exactly.
///
/// Instantiating regular expressions is a CPU-intensive operation; these
/// `static final` members are compiled once per application lifetime.
///
/// Structure mirrors the Kotlin source:
///   CompiledPatterns.Amount   → [CompiledPatterns.amount]
///   CompiledPatterns.Reference → [CompiledPatterns.reference]
///   CompiledPatterns.Account  → [CompiledPatterns.account]
///   CompiledPatterns.Balance  → [CompiledPatterns.balance]
///   CompiledPatterns.Merchant → [CompiledPatterns.merchant]
///   CompiledPatterns.HDFC     → [CompiledPatterns.hdfc]
///   CompiledPatterns.Cleaning → [CompiledPatterns.cleaning]
///   CompiledPatterns.Currency → [CompiledPatterns.currency]
///   CompiledPatterns.Date     → [CompiledPatterns.date]
///   CompiledPatterns.Time     → [CompiledPatterns.time]
///
/// Do NOT alter any regex string without a corresponding change in the Kotlin
/// source — these two files must always stay in sync.
library;

// ──────────────────────────────────────────────────────────────────────────────
// Root namespace (mirrors `object CompiledPatterns { … }`)
// ──────────────────────────────────────────────────────────────────────────────

/// Root accessor class — all pattern groups live here as nested classes so call
/// sites look identical to the Kotlin source:
///   Kotlin : `CompiledPatterns.Amount.RS_PATTERN.find(…)`
///   Dart   : `CompiledPatterns.amount.rsPattern.firstMatch(…)`
abstract class CompiledPatterns {
  CompiledPatterns._();

  static final amount = _Amount();
  static final reference = _Reference();
  static final account = _Account();
  static final balance = _Balance();
  static final merchant = _Merchant();
  static final hdfc = _Hdfc();
  static final cleaning = _Cleaning();
  static final currency = _Currency();
  static final date = _Date();
  static final time = _Time();
}

// ──────────────────────────────────────────────────────────────────────────────
// object Amount
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Amount`
class _Amount {
  // val RS_PATTERN = Regex("""Rs\.?\s*([0-9,]+(?:\.\d{2})?)""", IGNORE_CASE)
  final RegExp rsPattern = RegExp(
    r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val INR_PATTERN = Regex("""INR\s*([0-9,]+(?:\.\d{2})?)""", IGNORE_CASE)
  final RegExp inrPattern = RegExp(
    r'INR\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val RUPEE_SYMBOL_PATTERN = Regex("""₹\s*([0-9,]+(?:\.\d{2})?)""")
  final RegExp rupeeSymbolPattern = RegExp(
    r'₹\s*([0-9,]+(?:\.\d{2})?)',
  );

  // val ALL_PATTERNS = listOf(RS_PATTERN, INR_PATTERN, RUPEE_SYMBOL_PATTERN)
  late final List<RegExp> allPatterns = [
    rsPattern,
    inrPattern,
    rupeeSymbolPattern,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// object Reference
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Reference`
class _Reference {
  // val GENERIC_REF = Regex(
  //   """(?:Ref|Reference|Txn|Transaction)(?:\s+No)?[:\s]+([A-Z0-9]+)""",
  //   IGNORE_CASE)
  final RegExp genericRef = RegExp(
    r'(?:Ref|Reference|Txn|Transaction)(?:\s+No)?[:\s]+([A-Z0-9]+)',
    caseSensitive: false,
  );

  // val UPI_REF = Regex("""UPI[:\s]+([0-9]+)""", IGNORE_CASE)
  final RegExp upiRef = RegExp(
    r'UPI[:\s]+([0-9]+)',
    caseSensitive: false,
  );

  // val REF_NUMBER = Regex("""Reference\s+Number[:\s]+([A-Z0-9]+)""", IGNORE_CASE)
  final RegExp refNumber = RegExp(
    r'Reference\s+Number[:\s]+([A-Z0-9]+)',
    caseSensitive: false,
  );

  // val ALL_PATTERNS = listOf(GENERIC_REF, UPI_REF, REF_NUMBER)
  late final List<RegExp> allPatterns = [
    genericRef,
    upiRef,
    refNumber,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// object Account
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Account`
class _Account {
  // val AC_WITH_MASK = Regex(
  //   """(?:A/c|Account|Acct)(?:\s+No)?\.?\s+(\S+)""", IGNORE_CASE)
  final RegExp acWithMask = RegExp(
    r'(?:A/c|Account|Acct)(?:\s+No)?\.?\s+(\S+)',
    caseSensitive: false,
  );

  // val CARD_WITH_MASK = Regex("""Card\s+(\S+)""", IGNORE_CASE)
  final RegExp cardWithMask = RegExp(
    r'Card\s+(\S+)',
    caseSensitive: false,
  );

  // val ENDING_PATTERN = Regex(
  //   """(?:ending|ends with|ending with)\s+(\d{4})""", IGNORE_CASE)
  final RegExp endingPattern = RegExp(
    r'(?:ending|ends with|ending with)\s+(\d{4})',
    caseSensitive: false,
  );

  // val AC_NO_SLASH = Regex("""(?<![/])AC\s+(\S+)""", IGNORE_CASE)
  // Note: Dart does not support negative lookbehind with variable-length
  // assertions, but this lookbehind is fixed-width (one char) — supported.
  final RegExp acNoSlash = RegExp(
    r'(?<![/])AC\s+(\S+)',
    caseSensitive: false,
  );

  // val DEBIT_CREDIT_CARD = Regex("""(?:debit|credit)\s+card\s+(\S+)""", IGNORE_CASE)
  final RegExp debitCreditCard = RegExp(
    r'(?:debit|credit)\s+card\s+(\S+)',
    caseSensitive: false,
  );

  // val YOUR_ACCOUNT = Regex("""Your\s+(?:a/c|account|acct|card|#)\s*(\S+)""", IGNORE_CASE)
  final RegExp yourAccount = RegExp(
    r'Your\s+(?:a/c|account|acct|card|#)\s*(\S+)',
    caseSensitive: false,
  );

  // val LINKED_ACCOUNT = Regex("""linked\s+(?:a/c|account|acct)\s+(\S+)""", IGNORE_CASE)
  final RegExp linkedAccount = RegExp(
    r'linked\s+(?:a/c|account|acct)\s+(\S+)',
    caseSensitive: false,
  );

  // val ALL_PATTERNS = listOf(AC_WITH_MASK, CARD_WITH_MASK, ENDING_PATTERN,
  //                           AC_NO_SLASH, DEBIT_CREDIT_CARD, YOUR_ACCOUNT, LINKED_ACCOUNT)
  late final List<RegExp> allPatterns = [
    acWithMask,
    cardWithMask,
    endingPattern,
    acNoSlash,
    debitCreditCard,
    yourAccount,
    linkedAccount,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// object Balance
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Balance`
class _Balance {
  // val AVL_BAL_RS = Regex(
  //   """(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+Rs\.?\s*([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp avlBalRs = RegExp(
    r'(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val AVL_BAL_INR = Regex(
  //   """(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp avlBalInr = RegExp(
    r'(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val AVL_BAL_RUPEE = Regex(
  //   """(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+₹\s*([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp avlBalRupee = RegExp(
    r'(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+₹\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val AVL_BAL_NO_CURRENCY = Regex(
  //   """(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp avlBalNoCurrency = RegExp(
    r'(?:Bal|Balance|Avl Bal|Available Balance)[:\s]+([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val UPDATED_BAL_RS = Regex(
  //   """(?:Updated Balance|Remaining Balance)[:\s]+Rs\.?\s*([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp updatedBalRs = RegExp(
    r'(?:Updated Balance|Remaining Balance)[:\s]+Rs\.?\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val UPDATED_BAL_INR = Regex(
  //   """(?:Updated Balance|Remaining Balance)[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)""",
  //   IGNORE_CASE)
  final RegExp updatedBalInr = RegExp(
    r'(?:Updated Balance|Remaining Balance)[:\s]+INR\s*([0-9,]+(?:\.\d{2})?)',
    caseSensitive: false,
  );

  // val ALL_PATTERNS = listOf(AVL_BAL_RS, AVL_BAL_INR, AVL_BAL_RUPEE,
  //                           AVL_BAL_NO_CURRENCY, UPDATED_BAL_RS, UPDATED_BAL_INR)
  late final List<RegExp> allPatterns = [
    avlBalRs,
    avlBalInr,
    avlBalRupee,
    avlBalNoCurrency,
    updatedBalRs,
    updatedBalInr,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// object Merchant
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Merchant`
class _Merchant {
  // val TO_PATTERN = Regex(
  //   """to\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)""", IGNORE_CASE)
  final RegExp toPattern = RegExp(
    r'to\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)',
    caseSensitive: false,
  );

  // val FROM_PATTERN = Regex(
  //   """from\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)""", IGNORE_CASE)
  final RegExp fromPattern = RegExp(
    r'from\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref|\s+UPI)',
    caseSensitive: false,
  );

  // val AT_PATTERN = Regex("""at\s+([^\.\n]+?)(?:\s+on|\s+Ref)""", IGNORE_CASE)
  final RegExp atPattern = RegExp(
    r'at\s+([^\.\n]+?)(?:\s+on|\s+Ref)',
    caseSensitive: false,
  );

  // val FOR_PATTERN = Regex(
  //   """for\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref)""", IGNORE_CASE)
  final RegExp forPattern = RegExp(
    r'for\s+([^\.\n]+?)(?:\s+on|\s+at|\s+Ref)',
    caseSensitive: false,
  );

  // val ALL_PATTERNS = listOf(TO_PATTERN, FROM_PATTERN, AT_PATTERN, FOR_PATTERN)
  late final List<RegExp> allPatterns = [
    toPattern,
    fromPattern,
    atPattern,
    forPattern,
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// object HDFC
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.HDFC`
class _Hdfc {
  // val DLT_PATTERNS = listOf(
  //   Regex("^[A-Z]{2}-HDFCBK.*$"),
  //   Regex("^[A-Z]{2}-HDFC.*$"),
  //   Regex("^HDFC-[A-Z]+$"),
  //   Regex("^[A-Z]{2}-HDFCB.*$")
  // )
  final List<RegExp> dltPatterns = [
    RegExp(r'^[A-Z]{2}-HDFCBK.*$'),
    RegExp(r'^[A-Z]{2}-HDFC.*$'),
    RegExp(r'^HDFC-[A-Z]+$'),
    RegExp(r'^[A-Z]{2}-HDFCB.*$'),
  ];

  // val SALARY_PATTERN = Regex(
  //   """for\s+[^-]+-[^-]+-[^-]+\s+[A-Z]+\s+SALARY-([^\.\n]+)""", IGNORE_CASE)
  final RegExp salaryPattern = RegExp(
    r'for\s+[^-]+-[^-]+-[^-]+\s+[A-Z]+\s+SALARY-([^\.\n]+)',
    caseSensitive: false,
  );

  // val SIMPLE_SALARY_PATTERN = Regex("""SALARY[- ]([^\.\n]+?)(?:\s+Info|$)""", IGNORE_CASE)
  final RegExp simpleSalaryPattern = RegExp(
    r'SALARY[- ]([^\.\n]+?)(?:\s+Info|$)',
    caseSensitive: false,
  );

  // val INFO_PATTERN = Regex("""Info:\s*(?:UPI/)?([^/\.\n]+?)(?:/|$)""", IGNORE_CASE)
  final RegExp infoPattern = RegExp(
    r'Info:\s*(?:UPI/)?([^/\.\n]+?)(?:/|$)',
    caseSensitive: false,
  );

  // val VPA_WITH_NAME = Regex("""VPA\s+[^@\s]+@[^\s]+\s*\(([^)]+)\)""", IGNORE_CASE)
  final RegExp vpaWithName = RegExp(
    r'VPA\s+[^@\s]+@[^\s]+\s*\(([^)]+)\)',
    caseSensitive: false,
  );

  // val VPA_PATTERN = Regex("""VPA\s+([^@\s]+)@""", IGNORE_CASE)
  final RegExp vpaPattern = RegExp(
    r'VPA\s+([^@\s]+)@',
    caseSensitive: false,
  );

  // val SPENT_PATTERN = Regex("""at\s+([^\.\n]+?)\s+on\s+\d{2}""", IGNORE_CASE)
  final RegExp spentPattern = RegExp(
    r'at\s+([^\.\n]+?)\s+on\s+\d{2}',
    caseSensitive: false,
  );

  // val DEBIT_FOR_PATTERN = Regex("""debited\s+for\s+([^\.\n]+?)\s+on\s+\d{2}""", IGNORE_CASE)
  final RegExp debitForPattern = RegExp(
    r'debited\s+for\s+([^\.\n]+?)\s+on\s+\d{2}',
    caseSensitive: false,
  );

  // val MANDATE_PATTERN = Regex("""To\s+([^\n]+?)\s*(?:\n|\d{2}/\d{2})""", IGNORE_CASE)
  final RegExp mandatePattern = RegExp(
    r'To\s+([^\n]+?)\s*(?:\n|\d{2}/\d{2})',
    caseSensitive: false,
  );

  // val REF_SIMPLE = Regex("""Ref\s+(\d{9,12})""", IGNORE_CASE)
  final RegExp refSimple = RegExp(
    r'Ref\s+(\d{9,12})',
    caseSensitive: false,
  );

  // val UPI_REF_NO = Regex("""UPI\s+Ref\s+No\s+(\d{12})""", IGNORE_CASE)
  final RegExp upiRefNo = RegExp(
    r'UPI\s+Ref\s+No\s+(\d{12})',
    caseSensitive: false,
  );

  // val REF_NO = Regex("""Ref\s+No\.?\s+([A-Z0-9]+)""", IGNORE_CASE)
  final RegExp refNo = RegExp(
    r'Ref\s+No\.?\s+([A-Z0-9]+)',
    caseSensitive: false,
  );

  // val REF_END = Regex(
  //   """(?:Ref|Reference)[:.\\s]+([A-Z0-9]{6,})(?:\s*$|\s*Not\s+You)""",
  //   IGNORE_CASE)
  final RegExp refEnd = RegExp(
    r'(?:Ref|Reference)[:\.\s]+([A-Z0-9]{6,})(?:\s*$|\s*Not\s+You)',
    caseSensitive: false,
  );

  // val ACCOUNT_DEPOSITED = Regex(
  //   """deposited\s+in\s+(?:HDFC\s+Bank\s+)?A/c\s+(?:XX+)?(\d{3,6})""",
  //   IGNORE_CASE)
  final RegExp accountDeposited = RegExp(
    r'deposited\s+in\s+(?:HDFC\s+Bank\s+)?A/c\s+(?:XX+)?(\d{3,6})',
    caseSensitive: false,
  );

  // val ACCOUNT_FROM = Regex(
  //   """from\s+(?:HDFC\s+Bank\s+)?A/c\s+(?:XX+)?(\d{3,6})""", IGNORE_CASE)
  final RegExp accountFrom = RegExp(
    r'from\s+(?:HDFC\s+Bank\s+)?A/c\s+(?:XX+)?(\d{3,6})',
    caseSensitive: false,
  );

  // val ACCOUNT_SIMPLE = Regex("""HDFC\s+Bank\s+A/c\s+(\d{3,6})""", IGNORE_CASE)
  final RegExp accountSimple = RegExp(
    r'HDFC\s+Bank\s+A/c\s+(\d{3,6})',
    caseSensitive: false,
  );

  // val ACCOUNT_GENERIC = Regex("""A/c\s+(?:XX+)(\d{3,4})""", IGNORE_CASE)
  final RegExp accountGeneric = RegExp(
    r'A/c\s+(?:XX+)(\d{3,4})',
    caseSensitive: false,
  );

  // val AMOUNT_WILL_DEDUCT = Regex(
  //   """Rs\.?\s*([0-9,]+(?:\.\d{2})?)\s+will\s+be\s+deducted""", IGNORE_CASE)
  final RegExp amountWillDeduct = RegExp(
    r'Rs\.?\s*([0-9,]+(?:\.\d{2})?)\s+will\s+be\s+deducted',
    caseSensitive: false,
  );

  // val DEDUCTION_DATE = Regex(
  //   """deducted\s+on\s+(\d{2}/\d{2}/\d{2}),?\s*\d{2}:\d{2}:\d{2}""", IGNORE_CASE)
  final RegExp deductionDate = RegExp(
    r'deducted\s+on\s+(\d{2}/\d{2}/\d{2}),?\s*\d{2}:\d{2}:\d{2}',
    caseSensitive: false,
  );

  // val MANDATE_MERCHANT = Regex("""For\s+([^\n]+?)\s+mandate""", IGNORE_CASE)
  final RegExp mandateMerchant = RegExp(
    r'For\s+([^\n]+?)\s+mandate',
    caseSensitive: false,
  );

  // val UMN_PATTERN = Regex("""UMN\s+([a-zA-Z0-9@]+)""", IGNORE_CASE)
  final RegExp umnPattern = RegExp(
    r'UMN\s+([a-zA-Z0-9@]+)',
    caseSensitive: false,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// object Cleaning
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Cleaning`
///
/// Used by [BankParser.cleanMerchantName] in the exact order listed below.
class _Cleaning {
  // val TRAILING_PARENTHESES = Regex("""\s*\(.*?\)\s*$""")
  final RegExp trailingParentheses = RegExp(
    r'\s*\(.*?\)\s*$',
  );

  // val REF_NUMBER_SUFFIX = Regex("""\s+Ref\s+No.*""", IGNORE_CASE)
  final RegExp refNumberSuffix = RegExp(
    r'\s+Ref\s+No.*',
    caseSensitive: false,
  );

  // val DATE_SUFFIX = Regex("""\s+on\s+\d{2}.*""")
  final RegExp dateSuffix = RegExp(
    r'\s+on\s+\d{2}.*',
  );

  // val UPI_SUFFIX = Regex("""\s+UPI.*""", IGNORE_CASE)
  final RegExp upiSuffix = RegExp(
    r'\s+UPI.*',
    caseSensitive: false,
  );

  // val TIME_SUFFIX = Regex("""\s+at\s+\d{2}:\d{2}.*""")
  final RegExp timeSuffix = RegExp(
    r'\s+at\s+\d{2}:\d{2}.*',
  );

  // val TRAILING_DASH = Regex("""\s*-\s*$""")
  final RegExp trailingDash = RegExp(
    r'\s*-\s*$',
  );

  // val PVT_LTD = Regex(
  //   """(\s+PVT\.?\s*LTD\.?|\s+PRIVATE\s+LIMITED)$""", IGNORE_CASE)
  final RegExp pvtLtd = RegExp(
    r'(\s+PVT\.?\s*LTD\.?|\s+PRIVATE\s+LIMITED)$',
    caseSensitive: false,
  );

  // val LTD = Regex("""(\s+LTD\.?|\s+LIMITED)$""", IGNORE_CASE)
  final RegExp ltd = RegExp(
    r'(\s+LTD\.?|\s+LIMITED)$',
    caseSensitive: false,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// object Currency
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Currency`
class _Currency {
  // val ISO_CODE = Regex("""[A-Z]{3}""")
  final RegExp isoCode = RegExp(
    r'[A-Z]{3}',
  );

  // val SPECIFIC_ISO = { code: String -> Regex(code, IGNORE_CASE) }
  // Dart equivalent: call [specificIso] with a currency code string.
  RegExp specificIso(String code) => RegExp(code, caseSensitive: false);

  // val COMMON_CURRENCIES = Regex(
  //   """(?:INR|Rs\.?|₹|USD|EUR|GBP|AED|SAR)""", IGNORE_CASE)
  final RegExp commonCurrencies = RegExp(
    r'(?:INR|Rs\.?|₹|USD|EUR|GBP|AED|SAR)',
    caseSensitive: false,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// object Date
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Date`
class _Date {
  // dd/MM/yy   e.g. 20/10/25
  // val DD_MM_YY = Regex("""\d{1,2}/\d{1,2}/\d{2}""")
  final RegExp ddMmYy = RegExp(
    r'\d{1,2}/\d{1,2}/\d{2}',
  );

  // dd/MM/yyyy  e.g. 20/10/2025
  // val DD_MM_YYYY = Regex("""\d{1,2}/\d{1,2}/\d{4}""")
  final RegExp ddMmYyyy = RegExp(
    r'\d{1,2}/\d{1,2}/\d{4}',
  );

  // dd-MMM-yy   e.g. 20-OCT-25
  // val DD_MMM_YY = Regex("""\d{1,2}-[A-Za-z]{3}-\d{2}""", IGNORE_CASE)
  final RegExp ddMmmYy = RegExp(
    r'\d{1,2}-[A-Za-z]{3}-\d{2}',
    caseSensitive: false,
  );

  // dd-MM-yyyy  e.g. 20-10-2025
  // val DD_MM_YYYY_DASH = Regex("""\d{1,2}-\d{1,2}-\d{4}""")
  final RegExp ddMmYyyyDash = RegExp(
    r'\d{1,2}-\d{1,2}-\d{4}',
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// object Time
// ──────────────────────────────────────────────────────────────────────────────

/// `object CompiledPatterns.Time`
class _Time {
  // HH:mm:ss
  // val HH_MM_SS = Regex("""\d{1,2}:\d{2}:\d{2}""")
  final RegExp hhMmSs = RegExp(
    r'\d{1,2}:\d{2}:\d{2}',
  );

  // HH:mm
  // val HH_MM = Regex("""\d{1,2}:\d{2}""")
  final RegExp hhMm = RegExp(
    r'\d{1,2}:\d{2}',
  );
}
