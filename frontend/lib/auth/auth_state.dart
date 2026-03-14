part of 'auth_bloc.dart';

sealed class AuthState {}

/// Initial state before any check
final class AuthInitial extends AuthState {}

/// Checking existing session on app start
final class AuthLoading extends AuthState {}

/// Processing a sign-in or sign-up action
final class AuthActionLoading extends AuthState {}

/// User is authenticated
final class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String? fullName;
  final String role; // 'customer', 'staff', or 'owner'

  AuthAuthenticated({
    required this.userId,
    required this.email,
    this.fullName,
    this.role = 'customer',
  });

  bool get isAdmin => role == 'owner' || role == 'staff';
}

/// User is not authenticated
final class AuthUnauthenticated extends AuthState {}

/// An auth action failed
final class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState(this.message);
}

/// Password reset email was sent successfully
final class AuthPasswordResetSent extends AuthState {
  final String email;
  AuthPasswordResetSent(this.email);
}

/// Registration completed — may need email verification
final class AuthRegistered extends AuthState {
  final bool requiresEmailVerification;
  AuthRegistered({this.requiresEmailVerification = true});
}
