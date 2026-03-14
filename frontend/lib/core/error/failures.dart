import 'package:equatable/equatable.dart';

/// Sealed hierarchy of Failures — used in UseCase/BLoC layer.
/// Failures are user-facing; Exceptions are internal.

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Auth ──────────────────────────────────────────────────────────────────

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Invalid email or password. Please try again.');
}

final class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super('An account with this email already exists.');
}

final class UnverifiedEmailFailure extends AuthFailure {
  const UnverifiedEmailFailure()
      : super('Please verify your email address to continue.');
}

final class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super('Your session has expired. Please log in again.');
}

// ── Network ───────────────────────────────────────────────────────────────

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Request timed out. Please try again.');
}

// ── Data ─────────────────────────────────────────────────────────────────

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data unavailable.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

final class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors});

  @override
  List<Object?> get props => [message, fieldErrors];
}

// ── Payment ───────────────────────────────────────────────────────────────

final class PaymentFailure extends Failure {
  const PaymentFailure(super.message);
}

final class PaymentCancelledFailure extends PaymentFailure {
  const PaymentCancelledFailure() : super('Payment was cancelled.');
}

// ── Unexpected ────────────────────────────────────────────────────────────

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}