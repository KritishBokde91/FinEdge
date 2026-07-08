import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

extension on NotificationsTableData {
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      type: type,
      isRead: isRead,
    );
  }
}

extension on NotificationEntity {
  NotificationsTableCompanion toCompanion() {
    return NotificationsTableCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      timestamp: Value(timestamp),
      type: Value(type),
      isRead: Value(isRead),
    );
  }
}

class NotificationRepositoryImpl implements NotificationRepository {
  final AppDatabase _db;

  const NotificationRepositoryImpl(this._db);

  @override
  Stream<List<NotificationEntity>> watchAllNotifications() {
    return (_db.select(_db.notificationsTable)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<Result<void>> insertNotification(NotificationEntity notification) async {
    try {
      await _db
          .into(_db.notificationsTable)
          .insert(notification.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert notification', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String id) async {
    try {
      final query = _db.update(_db.notificationsTable)
        ..where((t) => t.id.equals(id));
      await query.write(const NotificationsTableCompanion(isRead: Value(true)));
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to mark notification as read', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      await _db.delete(_db.notificationsTable).go();
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to clear notifications', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
