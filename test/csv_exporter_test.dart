import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/backup/domain/services/csv_exporter_service.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  late Directory tempDir;
  late CsvExporterService csvService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('finsight_csv_test_');
    csvService = CsvExporterService(tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('CsvExporterService exports TransactionEntity list to valid CSV', () async {
    final transactions = [
      TransactionEntity(
        id: 'tx_1',
        smsId: 'sms_1',
        amount: 250.0,
        merchant: 'Starbucks Coffee',
        category: 'Food',
        timestamp: DateTime(2026, 3, 15, 14, 30),
        isIncome: false,
        accountSource: 'HDFC Bank',
        currency: 'INR',
        reference: 'UPI/123456/Payment',
      ),
      TransactionEntity(
        id: 'tx_2',
        smsId: 'sms_2',
        amount: 50000.0,
        merchant: 'Employer Corp',
        category: 'Salary',
        timestamp: DateTime(2026, 3, 1, 9, 0),
        isIncome: true,
        accountSource: 'ICICI Bank',
        currency: 'INR',
        reference: 'NEFT/SALARY/MARCH',
      ),
    ];

    final filePath = await csvService.exportTransactionEntities(
      transactions,
      fileName: 'test_export',
    );

    expect(File(filePath).existsSync(), isTrue);

    final fileContent = await File(filePath).readAsString();
    final lines = fileContent.trim().split('\n');

    expect(lines.length, equals(3)); // 1 header + 2 transactions
    expect(lines[0], equals(CsvExporterService.csvHeader.join(',')));
    expect(lines[1], contains('Starbucks Coffee'));
    expect(lines[1], contains('Food'));
    expect(lines[1], contains('Expense'));
    expect(lines[1], contains('250.0'));
    expect(lines[2], contains('Employer Corp'));
    expect(lines[2], contains('Salary'));
    expect(lines[2], contains('Income'));
    expect(lines[2], contains('50000.0'));
  });

  test('CsvExporterService escapes special characters in CSV fields', () async {
    final transactions = [
      TransactionEntity(
        id: 'tx_special',
        smsId: 'sms_special',
        amount: 99.0,
        merchant: 'Book, Store & "More"',
        category: 'Shopping',
        timestamp: DateTime(2026, 3, 10, 12, 0),
        isIncome: false,
        accountSource: 'SBI',
        currency: 'INR',
        reference: 'Ref with "quotes" and, commas',
      ),
    ];

    final filePath = await csvService.exportTransactionEntities(
      transactions,
      fileName: 'test_special',
    );

    final fileContent = await File(filePath).readAsString();
    expect(fileContent, contains('"Book, Store & ""More"""'));
    expect(fileContent, contains('"Ref with ""quotes"" and, commas"'));
  });
}
