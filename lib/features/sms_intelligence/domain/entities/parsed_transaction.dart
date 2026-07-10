import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:finsight_ai/core/enums/transaction_type.dart';

/// Parsed output from a bank SMS message.
///
/// Direct port of `parser-core/ParsedTransaction.kt`.
/// Field names, types, and defaults are preserved verbatim.
/// Kotlin `BigDecimal` → Dart `double`.
/// Kotlin `md5Hex` utility is implemented via the `crypto` package.
class ParsedTransaction {
  // --- Core fields (all required unless defaulted) ---

  final double amount;
  final TransactionType type;
  final String? merchant;
  final String? reference;
  final String? accountLast4;
  final double? balance;

  /// Available credit limit (credit card transactions only).
  /// Note: named `creditLimit` in Kotlin source but semantically is
  /// "available limit" — preserved as-is per porting rules.
  final double? creditLimit;

  final String smsBody;
  final String sender;
  final int timestamp;
  final String bankName;
  final String? transactionHash;
  final bool isFromCard;
  final String currency;
  final String? fromAccount;
  final String? toAccount;

  /// Mobile-money wallet (e.g. eMola, M-Pesa Mozambique): the SMS carries a
  /// running balance but no per-account number, because the whole wallet IS the
  /// account. When true, the app derives a single service-level account row from
  /// the balance instead of requiring an accountLast4.
  final bool isMobileWallet;

  const ParsedTransaction({
    required this.amount,
    required this.type,
    this.merchant,
    this.reference,
    this.accountLast4,
    this.balance,
    this.creditLimit,
    required this.smsBody,
    required this.sender,
    required this.timestamp,
    required this.bankName,
    this.transactionHash,
    this.isFromCard = false,
    this.currency = 'INR',
    this.fromAccount,
    this.toAccount,
    this.isMobileWallet = false,
  });

  // ---------------------------------------------------------------------------
  // fun generateTransactionId(): String
  // ---------------------------------------------------------------------------

  /// Generates a stable, deduplication-safe ID for this transaction.
  ///
  /// Port of `ParsedTransaction.generateTransactionId()`:
  /// ```
  /// val normalizedAmount = amount.setScale(2, HALF_UP)
  /// val smsBodyHash = md5Hex(smsBody).take(16)
  /// val data = "$sender|$normalizedAmount|$smsBodyHash"
  /// return md5Hex(data)
  /// ```
  String generateTransactionId() {
    // Kotlin: amount.setScale(2, HALF_UP)
    final normalizedAmount = amount.toStringAsFixed(2);

    // Kotlin: md5Hex(smsBody).take(16)
    final smsBodyHash = _md5Hex(smsBody).substring(0, 16);

    final data = '$sender|$normalizedAmount|$smsBodyHash';
    return _md5Hex(data);
  }

  // ---------------------------------------------------------------------------
  // copy() — Dart equivalent of Kotlin data class copy()
  // ---------------------------------------------------------------------------

  ParsedTransaction copyWith({
    double? amount,
    TransactionType? type,
    String? merchant,
    String? reference,
    String? accountLast4,
    double? balance,
    double? creditLimit,
    String? smsBody,
    String? sender,
    int? timestamp,
    String? bankName,
    String? transactionHash,
    bool? isFromCard,
    String? currency,
    String? fromAccount,
    String? toAccount,
    bool? isMobileWallet,
  }) {
    return ParsedTransaction(
      amount: amount ?? this.amount,
      type: type ?? this.type,
      merchant: merchant ?? this.merchant,
      reference: reference ?? this.reference,
      accountLast4: accountLast4 ?? this.accountLast4,
      balance: balance ?? this.balance,
      creditLimit: creditLimit ?? this.creditLimit,
      smsBody: smsBody ?? this.smsBody,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      bankName: bankName ?? this.bankName,
      transactionHash: transactionHash ?? this.transactionHash,
      isFromCard: isFromCard ?? this.isFromCard,
      currency: currency ?? this.currency,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      isMobileWallet: isMobileWallet ?? this.isMobileWallet,
    );
  }

  @override
  String toString() => 'ParsedTransaction('
      'amount=$amount, type=$type, merchant=$merchant, '
      'reference=$reference, accountLast4=$accountLast4, '
      'balance=$balance, sender=$sender, bankName=$bankName, '
      'currency=$currency'
      ')';
}

// ---------------------------------------------------------------------------
// Private helper — mirrors Kotlin's md5Hex top-level function in
// ParsedTransaction.kt (imported from a KMP shared util).
// ---------------------------------------------------------------------------

/// Returns the lowercase hexadecimal MD5 digest of [input].
String _md5Hex(String input) {
  final bytes = utf8.encode(input);
  final digest = md5.convert(bytes);
  return digest.toString(); // already hex, lowercase
}
