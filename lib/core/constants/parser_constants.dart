/// Parser-level constants.
///
/// Direct port of `parser-core/Constants.kt`.
/// Every constant name and value is preserved verbatim.
abstract class ParserConstants {
  ParserConstants._();

  // ignore: unused_field — mirrors Constants.Parsing nested object
  static const _parsing = _Parsing();

  // Convenience top-level accessors (mirrors Constants.Parsing.*)
  static const int minMerchantNameLength = _Parsing.minMerchantNameLength;
  static const String md5Algorithm = _Parsing.md5Algorithm;
  static const int amountScale = _Parsing.amountScale;
  static const double confidencePatternBased = _Parsing.confidencePatternBased;
  static const double confidenceAiBased = _Parsing.confidenceAiBased;
}

/// `object Constants.Parsing`
class _Parsing {
  const _Parsing();

  // const val MIN_MERCHANT_NAME_LENGTH = 2
  static const int minMerchantNameLength = 2;

  // const val MD5_ALGORITHM = "MD5"
  static const String md5Algorithm = 'MD5';

  // const val AMOUNT_SCALE = 2
  static const int amountScale = 2;

  // const val CONFIDENCE_PATTERN_BASED = 0.7f
  static const double confidencePatternBased = 0.7;

  // const val CONFIDENCE_AI_BASED = 0.9f
  static const double confidenceAiBased = 0.9;
}
