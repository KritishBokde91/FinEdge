/// Sealed class representing all types of system failures inside FinSight.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class SmsReadFailure extends Failure {
  const SmsReadFailure(super.message);
}

class BiometricAuthFailure extends Failure {
  const BiometricAuthFailure(super.message);
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class PredictionFailure extends Failure {
  const PredictionFailure(super.message);
}
