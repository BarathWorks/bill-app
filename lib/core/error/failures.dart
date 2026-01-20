import 'package:equatable/equatable.dart';

/// Base failure class for Either pattern error handling
abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Failure for local cache/storage operations
class CacheFailure extends Failure {
  const CacheFailure([super.message]);

  @override
  String toString() => message ?? 'Cache operation failed';
}

/// Failure when a requested item is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);

  @override
  String toString() => message ?? 'Requested item not found';
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);

  @override
  String toString() => message ?? 'Validation failed';
}

/// Failure for printer operations
class PrinterFailure extends Failure {
  const PrinterFailure([super.message]);

  @override
  String toString() => message ?? 'Printer operation failed';
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);

  @override
  String toString() => message ?? 'An unexpected error occurred';
}
