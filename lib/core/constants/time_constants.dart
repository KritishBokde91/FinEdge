/// Time duration conversion factors in milliseconds.
///
/// Ported from TimeConstants.kt.
abstract class TimeConstants {
  static const int millisPerSecond = 1000;
  static const int millisPerMinute = 60 * millisPerSecond;
  static const int millisPerHour = 60 * millisPerMinute;
  static const int millisPerDay = 24 * millisPerHour;
  static const int millisPer3Days = 3 * millisPerDay;
  static const int millisPer5Minutes = 5 * millisPerMinute;
}
