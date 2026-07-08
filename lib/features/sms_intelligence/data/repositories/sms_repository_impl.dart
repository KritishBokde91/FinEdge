import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/sms_entity.dart';
import '../../domain/repositories/sms_repository.dart';

extension on SmsMetadataTableData {
  SmsEntity toEntity() {
    return SmsEntity(
      id: id,
      sender: sender,
      body: body,
      timestamp: timestamp,
      isProcessed: isProcessed,
      confidence: confidence,
    );
  }
}

extension on SmsEntity {
  SmsMetadataTableCompanion toCompanion() {
    return SmsMetadataTableCompanion(
      id: Value(id),
      sender: Value(sender),
      body: Value(body),
      timestamp: Value(timestamp),
      isProcessed: Value(isProcessed),
      confidence: Value(confidence),
    );
  }
}

class SmsRepositoryImpl implements SmsRepository {
  final AppDatabase _db;

  const SmsRepositoryImpl(this._db);

  @override
  Stream<List<SmsEntity>> watchAllSms() {
    return (_db.select(_db.smsMetadataTable)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<Result<void>> insertSms(SmsEntity sms) async {
    try {
      await _db
          .into(_db.smsMetadataTable)
          .insert(sms.toCompanion(), mode: InsertMode.insertOrReplace);
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to insert SMS metadata', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<SmsEntity>>> getUnprocessedSms() async {
    try {
      final query = _db.select(_db.smsMetadataTable)
        ..where((t) => t.isProcessed.equals(false));
      final rows = await query.get();
      return Right(rows.map((row) => row.toEntity()).toList());
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch unprocessed SMS metadata', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsProcessed(List<String> ids) async {
    try {
      final query = _db.update(_db.smsMetadataTable)
        ..where((t) => t.id.isIn(ids));
      await query.write(
        const SmsMetadataTableCompanion(isProcessed: Value(true)),
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to mark SMS metadata as processed', e, stackTrace);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
