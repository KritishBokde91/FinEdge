import '../../../../core/error/result.dart';
import '../entities/sms_entity.dart';

/// Repository interface (contract) outlining operations for raw SMS data storage.
abstract class SmsRepository {
  /// Watches all SMS messages reactively
  Stream<List<SmsEntity>> watchAllSms();

  /// Saves a raw SMS message details
  Future<Result<void>> insertSms(SmsEntity sms);

  /// Fetches unprocessed SMS messages queue
  Future<Result<List<SmsEntity>>> getUnprocessedSms();

  /// Marks a list of SMS messages as processed
  Future<Result<void>> markAsProcessed(List<String> ids);
}
