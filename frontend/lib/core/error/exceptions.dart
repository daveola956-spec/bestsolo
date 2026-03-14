/// Custom exception types for the BEST SOLO app.
/// All extend [AppException] so they can be caught uniformly.

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic original;

  const AppException({
    required this.message,
    this.code,
    this.original,
  });

  @override
  String toString() => 'AppException($code): $message';
}

// ── Auth ──────────────────────────────────────────────────────────────────

class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.original});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super(
          message: 'Invalid email or password.',
          code: 'invalid_credentials',
        );
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException()
      : super(
          message: 'No account found with this email.',
          code: 'user_not_found',
        );
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
      : super(
          message: 'An account with this email already exists.',
          code: 'email_in_use',
        );
}

class UnverifiedEmailException extends AuthException {
  const UnverifiedEmailException()
      : super(
          message: 'Please verify your email before logging in.',
          code: 'email_unverified',
        );
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
      : super(
          message: 'Your session has expired. Please log in again.',
          code: 'session_expired',
        );
}

// ── Network ───────────────────────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'no_network',
    super.original,
  });
}

class TimeoutException extends AppException {
  const TimeoutException()
      : super(
          message: 'Request timed out. Please try again.',
          code: 'timeout',
        );
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException({
    required super.message,
    this.statusCode,
    super.code = 'server_error',
    super.original,
  });
}

// ── Data ─────────────────────────────────────────────────────────────────

class CachedException extends AppException {
  const CachedException({
    super.message = 'Failed to read cached data.',
    super.code = 'cache_error',
  });
}

class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.code = 'not_found'});
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  const ValidationException({
    required super.message,
    super.code = 'validation_error',
    this.fieldErrors,
  });
}

class DataException extends AppException {
  const DataException({required super.message, super.code = 'data_error', super.original});
}

// ── Payment ───────────────────────────────────────────────────────────────

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code = 'payment_error',
    super.original,
  });
}

class PaymentCancelledException extends PaymentException {
  const PaymentCancelledException()
      : super(
          message: 'Payment was cancelled.',
          code: 'payment_cancelled',
        );
}