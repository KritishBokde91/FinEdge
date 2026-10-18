import 'dart:io';
import '../../../../core/database/drift_database.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

/// Service exporting transactions to CSV spreadsheets and clearing outdated files.
///
/// Ported from CsvExporter.kt.
class CsvExporterService {
  static const String _exportDirName = 'exports';

  final Directory cacheDir;

  const CsvExporterService(this.cacheDir);

  /// Header row matching CsvExporter.kt columns.
  static const List<String> csvHeader = [
    'Date',
    'Time',
    'Merchant',
    'Category',
    'Type',
    'Amount',
    'Currency',
    'Bank',
    'Account',
    'Balance After',
    'Description',
    'SMS Body'
  ];

  /// Exports [transactions] list to a local CSV file.
  ///
  /// Cleans up exports older than 24 hours. Returns the absolute file path.
  Future<String> exportTransactions(
    List<TransactionsTableData> transactions, {
    String? fileName,
  }) async {
    final exportDir = Directory('${cacheDir.path}/$_exportDirName');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    // Clean up old exports
    _cleanOldExports(exportDir);

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '').replaceAll('.', '');
    final finalFileName = fileName ?? 'transactions_$timestamp';
    final file = File('${exportDir.path}/$finalFileName.csv');

    final buffer = StringBuffer();
    // Write Header
    buffer.writeln(csvHeader.map(_escapeCsvField).join(','));

    // Write Records
    for (final tx in transactions) {
      final dateStr = tx.timestamp.toIso8601String().split('T').first;
      final timeStr = tx.timestamp.toIso8601String().split('T').last.split('.').first;
      final typeLabel = tx.isIncome ? 'Income' : 'Expense';

      final row = [
        dateStr,
        timeStr,
        tx.merchant,
        tx.category,
        typeLabel,
        tx.amount.toString(),
        tx.currency,
        tx.accountSource, // Bank Name
        '', // Account Last 4
        '', // Balance After
        '', // Description
        '' // SMS Body
      ];

      buffer.writeln(row.map(_escapeCsvField).join(','));
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  /// Exports domain [TransactionEntity] list to a local CSV file.
  Future<String> exportTransactionEntities(
    List<TransactionEntity> transactions, {
    String? fileName,
  }) async {
    final exportDir = Directory('${cacheDir.path}/$_exportDirName');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    // Clean up old exports
    _cleanOldExports(exportDir);

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '').replaceAll('.', '');
    final finalFileName = fileName ?? 'transactions_$timestamp';
    final file = File('${exportDir.path}/$finalFileName.csv');

    final buffer = StringBuffer();
    // Write Header
    buffer.writeln(csvHeader.map(_escapeCsvField).join(','));

    // Write Records
    for (final tx in transactions) {
      final dateStr = tx.timestamp.toIso8601String().split('T').first;
      final timeStr = tx.timestamp.toIso8601String().split('T').last.split('.').first;
      final typeLabel = tx.isIncome ? 'Income' : 'Expense';

      final row = [
        dateStr,
        timeStr,
        tx.merchant,
        tx.category,
        typeLabel,
        tx.amount.toString(),
        tx.currency,
        tx.accountSource, // Bank Name
        '', // Account Last 4
        '', // Balance After
        tx.reference ?? '', // Description / Reference
        '' // SMS Body
      ];

      buffer.writeln(row.map(_escapeCsvField).join(','));
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  void _cleanOldExports(Directory exportDir) {
    try {
      final oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
      final files = exportDir.listSync();
      for (final entity in files) {
        if (entity is File && entity.lastModifiedSync().isBefore(oneDayAgo)) {
          entity.deleteSync();
        }
      }
    } catch (_) {}
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n') || field.contains('\r')) {
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }
}
