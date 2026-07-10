/// Transaction classification enum.
///
/// Direct port of `parser-core/TransactionType.kt`.
/// Every value name is preserved verbatim — do not rename.
enum TransactionType {
  income,
  expense,
  credit,
  transfer,
  investment,
  balanceUpdate,
}
