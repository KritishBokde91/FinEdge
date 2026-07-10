import 'package:finsight_ai/core/enums/transaction_type.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/base_indian_bank_parser.dart';

/// HDFC Mutual Fund parser for SIP purchase and redemption messages.
///
/// Direct port of `parser-core/bank/HDFCMutualFundParser.kt`.
/// Handles senders like "AD-HDFCMF-AC", "VM-HDFCMF".
class HdfcMutualFundParser extends BaseIndianBankParser {
  @override
  String getBankName() => 'HDFC Mutual Fund';

  @override
  bool canHandle(String sender) =>
      sender.toUpperCase().contains('HDFCMF');

  @override
  bool isTransactionMessage(String message) {
    final lower = message.toLowerCase();
    const keywords = [
      'sip purchase',
      'has been processed',
      'folio',
      'nav',
      'redemption',
    ];
    return keywords.any((kw) => lower.contains(kw));
  }

  @override
  double? extractAmount(String message) {
    final pattern = RegExp(r'Rs\.?\s*([\d,]+\.?\d*)');
    final m = pattern.firstMatch(message);
    if (m != null) {
      final str = m.group(1)!.replaceAll(',', '');
      return double.tryParse(str);
    }
    return null;
  }

  @override
  String? extractMerchant(String message, String sender) {
    final pattern = RegExp(r'under\s+(.+?)\s+for', caseSensitive: false);
    final m = pattern.firstMatch(message);
    return m?.group(1)?.trim();
  }

  @override
  TransactionType? extractTransactionType(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('sip purchase') || lower.contains('purchase')) {
      return TransactionType.investment;
    }
    if (lower.contains('redemption')) return TransactionType.income;
    return null;
  }

  @override
  double? extractBalance(String message) => null;

  @override
  String? extractAccountLast4(String message) => null;
}
