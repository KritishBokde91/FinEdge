import 'package:fpdart/fpdart.dart';
import 'failures.dart';

/// Unified result type representation for repository return values.
/// Forces the caller to handle both failure and success cases functional-style.
typedef Result<T> = Either<Failure, T>;
