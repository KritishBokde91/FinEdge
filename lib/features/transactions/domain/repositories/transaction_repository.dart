import '../../../../core/error/result.dart';
import '../entities/transaction_entity.dart';

/// Repository interface (contract) outlining all financial ledger transactions
/// operations. Independent of databases or framework engines.
abstract class TransactionRepository {
  /// Watches all transactions in the database reactively
  Stream<List<TransactionEntity>> watchAllTransactions();

  /// Fetches a single transaction by ID
  Future<Result<TransactionEntity>> getTransactionById(String id);

  /// Saves a new transaction record
  Future<Result<void>> insertTransaction(TransactionEntity transaction);

  /// Updates a transaction details notes/categories
  Future<Result<void>> updateTransaction(TransactionEntity transaction);

  /// Deletes a transaction from the database
  Future<Result<void>> deleteTransaction(String id);

  /// Helper to calculate aggregate sum grouped by category
  Future<Result<Map<String, double>>> calculateCategoryAggregates();
}
