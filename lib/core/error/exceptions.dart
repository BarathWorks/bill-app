/// Custom exception classes for error handling

/// Exception thrown when there is an error with local cache/storage
class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);

  @override
  String toString() => message ?? 'CacheException: An error occurred with local storage';
}

/// Exception thrown when a requested item is not found
class NotFoundException implements Exception {
  final String? message;

  NotFoundException([this.message]);

  @override
  String toString() => message ?? 'NotFoundException: Requested item not found';
}

/// Exception thrown when there is a validation error
class ValidationException implements Exception {
  final String? message;

  ValidationException([this.message]);

  @override
  String toString() => message ?? 'ValidationException: Validation failed';
}

/// Exception thrown when there is a printer-related error
class PrinterException implements Exception {
  final String? message;

  PrinterException([this.message]);

  @override
  String toString() => message ?? 'PrinterException: Printer error occurred';
}
