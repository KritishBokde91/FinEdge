/// Helper mapping and transforming transaction merchant details.
///
/// Ported from ParsedTransactionMapper.kt.
class ParsedTransactionMapper {
  /// Normalizes merchant names to proper mixed case formatting if all-uppercase.
  static String normalizeMerchantName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Unknown Merchant';

    // If it is entirely uppercase, convert to proper case
    if (trimmed == trimmed.toUpperCase()) {
      return trimmed.toLowerCase().split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }

    return trimmed;
  }
}
