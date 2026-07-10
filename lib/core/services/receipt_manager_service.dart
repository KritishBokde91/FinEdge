import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Manager for local storage and retrieval of receipt photos.
///
/// Ported from ReceiptManager.kt.
class ReceiptManagerService {
  const ReceiptManagerService();

  Future<Directory> get _receiptsDir async {
    final docs = await getApplicationDocumentsDirectory();
    return Directory('${docs.path}/receipts');
  }

  /// Saves receipt image from [sourcePath] to a local unique path under receipts directory.
  Future<String?> saveReceipt(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) return null;

      final dir = await _receiptsDir;
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetFile = File('${dir.path}/$fileName');

      // Copy source file to local receipts directory
      await sourceFile.copy(targetFile.path);
      return 'receipts/$fileName';
    } catch (_) {
      return null;
    }
  }

  /// Deletes receipt image by its relative path.
  Future<void> deleteReceipt(String relativePath) async {
    try {
      final docs = await getApplicationDocumentsDirectory();
      final file = File('${docs.path}/$relativePath');
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (_) {}
  }

  /// Returns the absolute path of a receipt from its relative path.
  Future<String> getReceiptAbsolutePath(String relativePath) async {
    final docs = await getApplicationDocumentsDirectory();
    return '${docs.path}/$relativePath';
  }

  /// Deletes all receipt photos.
  Future<void> deleteAllReceipts() async {
    try {
      final dir = await _receiptsDir;
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  }
}
