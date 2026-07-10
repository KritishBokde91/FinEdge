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

  @override
  Future<SubscriptionEntity?> matchTransactionToSubscription(
    String merchant,
    double amount,
  ) async {
    final query = _db.select(_db.subscriptionsTable)
      ..where((t) => t.isActive.equals(true) & t.merchant.equals(merchant));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final entity = row.toEntity();
    final tolerance = entity.amount * 0.05;
    final diff = (entity.amount - amount).abs();
    if (diff <= tolerance) {
      return entity;
    }
    return null;
  }

  @override
  Future<void> updateNextPaymentDateAfterCharge(
    String subscriptionId,
    DateTime chargeDate,
  ) async {
    final query = _db.select(_db.subscriptionsTable)
      ..where((t) => t.id.equals(subscriptionId));
    final row = await query.getSingleOrNull();
    if (row == null) return;

    final nextDate = _advanceDate(chargeDate, row.billingCycle);
    await (_db.update(_db.subscriptionsTable)..where((t) => t.id.equals(subscriptionId)))
        .write(SubscriptionsTableCompanion(nextBillingDate: Value(nextDate)));
  }

  DateTime _advanceDate(DateTime date, String billingCycle) {
    switch (billingCycle.toUpperCase()) {
      case 'WEEKLY':
        return date.add(const Duration(days: 7));
      case 'MONTHLY':
        // Standard month advance: adding 31 days or using a calendar check
        final nextMonth = date.month == 12 ? 1 : date.month + 1;
        final nextYear = date.month == 12 ? date.year + 1 : date.year;
        // Handle end-of-month clamping safely
        final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final targetDay = date.day > lastDayOfNextMonth ? lastDayOfNextMonth : date.day;
        return DateTime(nextYear, nextMonth, targetDay, date.hour, date.minute, date.second);
      case 'QUARTERLY':
        var nextMonth = date.month + 3;
        var nextYear = date.year;
        if (nextMonth > 12) {
          nextMonth -= 12;
          nextYear += 1;
        }
        final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final targetDay = date.day > lastDayOfNextMonth ? lastDayOfNextMonth : date.day;
        return DateTime(nextYear, nextMonth, targetDay, date.hour, date.minute, date.second);
      case 'SEMI-ANNUAL':
      case 'SEMI ANNUAL':
      case 'SEMIANNUAL':
        var nextMonth = date.month + 6;
        var nextYear = date.year;
        if (nextMonth > 12) {
          nextMonth -= 12;
          nextYear += 1;
        }
        final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final targetDay = date.day > lastDayOfNextMonth ? lastDayOfNextMonth : date.day;
        return DateTime(nextYear, nextMonth, targetDay, date.hour, date.minute, date.second);
      case 'ANNUAL':
      case 'YEARLY':
        return DateTime(date.year + 1, date.month, date.day, date.hour, date.minute, date.second);
      default:
        // Fallback to monthly
        final nextMonth = date.month == 12 ? 1 : date.month + 1;
        final nextYear = date.month == 12 ? date.year + 1 : date.year;
        final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final targetDay = date.day > lastDayOfNextMonth ? lastDayOfNextMonth : date.day;
        return DateTime(nextYear, nextMonth, targetDay, date.hour, date.minute, date.second);
    }
  }
}
