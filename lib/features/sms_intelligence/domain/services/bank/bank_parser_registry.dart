import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';

/// Registry of bank parsers.
///
/// Direct port of `parser-core/bank/BankParserRegistry.kt`.
class BankParserRegistry {
  final List<BankParser> _parsers;

  BankParserRegistry(this._parsers);

  /// Returns the first parser that can handle the given sender.
  BankParser? getParser(String sender) {
    for (final parser in _parsers) {
      if (parser.canHandle(sender)) {
        return parser;
      }
    }
    return null;
  }

  /// Returns all registered parsers.
  List<BankParser> all() => _parsers;
}
