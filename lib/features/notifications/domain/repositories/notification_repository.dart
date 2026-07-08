import '../../../../core/error/result.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Stream<List<NotificationEntity>> watchAllNotifications();
  Future<Result<void>> insertNotification(NotificationEntity notification);
  Future<Result<void>> markAsRead(String id);
  Future<Result<void>> clearAll();
}
