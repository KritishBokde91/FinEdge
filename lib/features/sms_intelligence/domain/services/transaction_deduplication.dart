import '../../../../core/database/drift_database.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

/// Service checking for duplicate UPI transactions.
///
/// Ported from TransactionDeduplication.kt.
class TransactionDeduplication {
  static final RegExp upiReferencePattern = RegExp(r'^\d{12}$');

  /// Sliding window duration for identifying duplicates (3 minutes).
  static const Duration upiDuplicateWindow = Duration(minutes: 3);

  /// Checks if [reference] matches a 12-digit UPI pattern.
  static bool hasUpiReference(String? reference) {
    if (reference == null) return false;
    return upiReferencePattern.hasMatch(reference);
  }

  /// Determines if two transactions represent the same UPI event (using TransactionsTableData).
  static bool isSameUpiTransaction({
    required TransactionsTableData existing,
    required String? incomingReference,
    required bool incomingIsIncome,
    required double incomingAmount,
    required DateTime incomingDateTime,
    Duration window = upiDuplicateWindow,
  }) {
    if (!hasUpiReference(existing.reference) || !hasUpiReference(incomingReference)) return false;
    if (existing.reference != incomingReference) return false;
    if (existing.isIncome != incomingIsIncome) return false;
    if ((existing.amount - incomingAmount).abs() > 0.001) return false;

    final gap = existing.timestamp.difference(incomingDateTime).abs();
    return gap <= window;
  }

  /// Determines if two TransactionEntity objects represent the same UPI event.
  static bool isSameUpiTransactionEntity(
    TransactionEntity existing,
    TransactionEntity incoming, {
    Duration window = upiDuplicateWindow,
  }) {
    if (!hasUpiReference(existing.reference) || !hasUpiReference(incoming.reference)) return false;
    if (existing.reference != incoming.reference) return false;
    if (existing.isIncome != incoming.isIncome) return false;
    if (existing.currency != incoming.currency) return false;
    if ((existing.amount - incoming.amount).abs() > 0.001) return false;
    if (!accountsMatch(existing.accountSource, incoming.accountSource)) return false;

    final gap = existing.timestamp.difference(incoming.timestamp).abs();
    return gap <= window;
  }

  /// Determines if the existing transaction should be replaced by the incoming one.
  static bool shouldReplaceWithIncoming(
    TransactionEntity existing,
    TransactionEntity incoming,
  ) {
    if (!isSameUpiTransactionEntity(existing, incoming)) return false;

    final existingIsPartnerBank = existing.accountSource.toLowerCase() == 'state bank of india';
    final incomingIsPartnerBank = incoming.accountSource.toLowerCase() == 'state bank of india';
    if (existingIsPartnerBank && !incomingIsPartnerBank) return true;
    if (!existingIsPartnerBank && incomingIsPartnerBank) return false;

    // In Kotlin, it checks: existing.balanceAfter == null && incoming.balanceAfter != null.
    // In Dart we do not store balance on TransactionEntity itself, so we default to false.
    return false;
  }

  /// Finds duplicate transactions to delete.
  static List<String> duplicateIdsToDelete(List<TransactionEntity> transactions) {
    final eligible = transactions.where((tx) => hasUpiReference(tx.reference)).toList();
    final grouped = <String, List<TransactionEntity>>{};

    for (final tx in eligible) {
      final key = '${tx.reference}|${tx.amount.toStringAsFixed(2)}|${tx.accountSource}|${tx.isIncome}|${tx.currency}';
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    final toDelete = <String>[];
    for (final group in grouped.values) {
      toDelete.addAll(_duplicateIdsFromGroup(group));
    }
    return toDelete;
  }

  static List<String> _duplicateIdsFromGroup(List<TransactionEntity> group) {
    final duplicateClusters = <List<TransactionEntity>>[];

    final sorted = List<TransactionEntity>.from(group)
      ..sort((a, b) {
        final cmp = a.timestamp.compareTo(b.timestamp);
        if (cmp != 0) return cmp;
        return a.id.compareTo(b.id);
      });

    for (final tx in sorted) {
      var matchedCluster = duplicateClusters.firstWhere(
        (cluster) => cluster.any((prev) => isSameUpiTransactionEntity(prev, tx)),
        orElse: () => [],
      );

      if (matchedCluster.isEmpty) {
        matchedCluster = [tx];
        duplicateClusters.add(matchedCluster);
      } else {
        matchedCluster.add(tx);
      }
    }

    final result = <String>[];
    for (final cluster in duplicateClusters) {
      if (cluster.isEmpty) continue;

      // Find keeper: State Bank of India preferred, then oldest, then first id
      final keeper = cluster.reduce((best, current) {
        final bestIsSBI = best.accountSource.toLowerCase() == 'state bank of india';
        final currentIsSBI = current.accountSource.toLowerCase() == 'state bank of india';

        if (bestIsSBI != currentIsSBI) {
          return currentIsSBI ? current : best;
        }

        final timeCmp = best.timestamp.compareTo(current.timestamp);
        if (timeCmp != 0) {
          return timeCmp < 0 ? best : current;
        }

        return best.id.compareTo(current.id) <= 0 ? best : current;
      });

      for (final tx in cluster) {
        if (tx.id != keeper.id) {
          result.add(tx.id);
        }
      }
    }

    return result;
  }

  static bool accountsMatch(String? existingAccount, String? incomingAccount) {
    if (existingAccount == null || existingAccount.trim().isEmpty) return true;
    if (incomingAccount == null || incomingAccount.trim().isEmpty) return true;
    return existingAccount.trim() == incomingAccount.trim();
  }
}
