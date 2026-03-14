part of 'auth_bloc.dart';

sealed class AuthEvent {}

/// Called on app start — checks if user already has a valid session.
final class AuthCheckRequested extends AuthEvent {}

/// User is signing in with email and password.
final class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});
}

/// User is registering a new account.
final class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String? phone;

  AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });
}

/// User is signing out.
final class AuthSignOutRequested extends AuthEvent {}

/// User requests a password reset email.
final class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  AuthPasswordResetRequested(this.email);
}
