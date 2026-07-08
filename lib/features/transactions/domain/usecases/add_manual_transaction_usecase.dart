import 'package:uuid/uuid.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

/// Input model for creating a manual transaction.
///
/// Mirrors PennyWise's [ManualTransactionInput] from TransactionMutationModels.kt.
class ManualTransactionInput {
  final double amount;
  final String merchantName;
  final String category;
  final bool isIncome;
  final DateTime? occurredAt;
  final String accountSource;
  final String currency;

  const ManualTransactionInput({
    required this.amount,
    required this.merchantName,
    required this.category,
    required this.isIncome,
    this.occurredAt,
    this.accountSource = 'Manual Entry',
    this.currency = 'INR',
  });
}

/// Sealed result for manual transaction creation.
sealed class ManualTransactionResult {
  const ManualTransactionResult();
}

class ManualTransactionSuccess extends ManualTransactionResult {
  final String transactionId;
  const ManualTransactionSuccess(this.transactionId);
}

class ManualTransactionValidationError extends ManualTransactionResult {
  final String message;
  const ManualTransactionValidationError(this.message);
}

class ManualTransactionDbError extends ManualTransactionResult {
  final String message;
  const ManualTransactionDbError(this.message);
}

/// Validates and persists a manually-entered transaction.
///
/// Ported from PennyWise's [CreateManualTransactionUseCase.kt]:
///   - Validates: amount > 0, merchant name required, category required
///   - Generates a UUID v4 for the new transaction ID
///   - Sets timestamp to now if not provided
///   - Inserts via [TransactionRepository.insertTransaction]
class AddManualTransactionUseCase {
  final TransactionRepository _repository;
  static const _uuid = Uuid();

  const AddManualTransactionUseCase(this._repository);

  Future<ManualTransactionResult> execute(ManualTransactionInput input) async {
    // ── Validation (mirrors PennyWise's validate() method) ──
    final validationError = _validate(input);
    if (validationError != null) {
      return ManualTransactionValidationError(validationError);
    }

    final id = _uuid.v4();
    final timestamp = input.occurredAt ?? DateTime.now();

    final entity = TransactionEntity(
      id: id,
      smsId: null, // manual transactions have no associated SMS
      amount: input.amount,
      merchant: input.merchantName.trim(),
      category: input.category.trim(),
      timestamp: timestamp,
      isIncome: input.isIncome,
      accountSource: input.accountSource.trim().isNotEmpty
          ? input.accountSource.trim()
          : 'Manual Entry',
    );

    final result = await _repository.insertTransaction(entity);
    return result.fold(
      (failure) => ManualTransactionDbError(failure.message),
      (_) => ManualTransactionSuccess(id),
    );
  }

  /// Returns an error message string if validation fails, null if valid.
  String? _validate(ManualTransactionInput input) {
    if (input.amount <= 0) return 'Amount must be greater than zero';
    if (input.merchantName.trim().isEmpty) return 'Merchant name is required';
    if (input.category.trim().isEmpty) return 'Category is required';
    return null;
  }
}
