import 'package:talker_flutter/talker_flutter.dart';

/// Central structured logging controller for FinSight.
/// Uses the Talker library to maintain thread-safe, categorizable diagnostics.
abstract class AppLogger {
  static final Talker talker = TalkerFlutter.init();

  static void d(String message) {
    talker.debug(message);
  }

  static void i(String message) {
    talker.info(message);
  }

  static void w(String message) {
    talker.warning(message);
  }

  static void e(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.handle(exception ?? message, stackTrace, message);
  }

  static void performance(String message, Duration duration) {
    talker.log('Performance: $message in ${duration.inMilliseconds}ms');
  }
}
