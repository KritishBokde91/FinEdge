import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing system notification triggers.
///
/// Ported from BankNotificationRepository.kt.
class BankNotificationRepository {
  final BankNotificationDao _dao;

  const BankNotificationRepository(this._dao);

  Future<int> insertNotification(BankNotificationsTableCompanion entry) => _dao.insertNotification(entry);

  Future<List<BankNotificationsTableData>> getNotifications() => _dao.getAllNotifications();
}
