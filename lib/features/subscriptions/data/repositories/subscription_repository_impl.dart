import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';

extension on SubscriptionsTableData {
  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      merchant: merchant,
      amount: amount,
      billingCycle: billingCycle,
      nextBillingDate: nextBillingDate,
      isActive: isActive,
    );
  }
}

extension on SubscriptionEntity {
  SubscriptionsTableCompanion toCompanion() {
    return SubscriptionsTableCompanion(
      id: Value(id),
      merchant: Value(merchant),
      amount: Value(amount),
      billingCycle: Value(billingCycle),
      nextBillingDate: Value(nextBillingDate),
      isActive: Value(isActive),
    );
  }
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final AppDatabase _db;

  const SubscriptionRepositoryImpl(this._db);

  @override
  Stream<List<SubscriptionEntity>> watchAllSubscriptions() {
    return _db.select(_db.subscriptionsTable).watch().map(
          (rows) => rows.map((row) => row.toEntity()).toList(),
        );
  }

  @override
  Future<Result<void>> insertSubscription(SubscriptionEntity subscription) async {
    try {
      await _db
          .into(_db.subscriptionsTable)
          .insert(subscription.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert subscription', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateSubscription(SubscriptionEntity subscription) async {
    try {
      await _db
          .update(_db.subscriptionsTable)
          .replace(subscription.toCompanion());
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update subscription', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteSubscription(String id) async {
    try {
      final query = _db.delete(_db.subscriptionsTable)
        ..where((t) => t.id.equals(id));
      await query.go();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to delete subscription', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
