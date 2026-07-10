/// Central application constants.
///
/// Ported from Constants.kt to avoid hardcoded configuration values.
abstract class AppConstants {
  /// SMS Syncing & Importing configurations.
  static const smsDefaultBatchSize = 100;
  static const smsPreviewLength = 200;
  static const smsQueryLimit = 100;
  static const smsInitialScanMonths = 3;
  static const smsScanningDelayMs = 3000;

  /// UI constants.
  static const uiButtonWidthRatio = 0.8;
  static const uiProgressStrokeWidth = 2.0;

  /// Database configuration.
  static const databaseName = 'finsight_database';
  static const databaseVersion = 2;
  static const databaseTxHashDefault = '';

  /// Background Work / Sync Scheduling.
  static const workSmsReaderName = 'sms_reader_work';
  static const workPeriodicIntervalHours = 24;
  static const workInitialDelayMinutes = 15;

  /// Transaction & SMS parsing metrics.
  static const parseMinMerchantNameLength = 2;
  static const parseMd5Algorithm = 'MD5';
  static const parseAmountScale = 2;
  static const parseConfidencePatternBased = 0.7;
  static const parseConfidenceAiBased = 0.9;

  /// LLM Local Model download parameters.
  static const modelUrl =
      'https://pub-fcfb3ffddb184540a758a7fe68249908.r2.dev/Qwen2.5-1.5B-Instruct-q8-ekv4096.litertlm';
  static const modelFileName = 'Qwen2.5-1.5B-Instruct-q8-ekv4096.litertlm';
  static const modelSizeMb = 1524;
  static const modelSizeBytes = 1597931520;
  static const modelRequiredSpaceBytes = 3195863040; // ~3.0GB (2x model size for safety)

  /// External community & support links.
  static const linkDiscord = 'https://discord.gg/H3xWeMWjKQ';
  static const linkGithub = 'https://github.com/sarim2000/pennywiseai-tracker';
  static const linkWebParser = 'https://pennywise.zynth.dev';
}
