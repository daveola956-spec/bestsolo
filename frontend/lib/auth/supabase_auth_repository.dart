import 'package:supabase_flutter/supabase_flutter.dart' show User;
import '../core/error/exceptions.dart';
import '../core/error/failures.dart';
import '../services/auth_service.dart';
import 'auth_repository.dart';

/// Supabase implementation of [AuthRepository].
class SupabaseAuthRepository implements AuthRepository {
  final AuthService _authService;

  SupabaseAuthRepository(this._authService);

  @override
  User? get currentUser => _authService.currentUser;

  @override
  bool get isLoggedIn => _authService.isLoggedIn;

  @override
  Stream<User?> get userStream =>
      _authService.authStateChanges.map((state) => state.session?.user);

  // ── Sign in ───────────────────────────────────────────────────────────────

  @override
  Future<({User user, Failure? failure})> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signIn(email: email, password: password);
      return (user: user, failure: null);
    } on InvalidCredentialsException {
      return (
        user: _authService.currentUser ?? _dummyUser(),
        failure: const InvalidCredentialsFailure(),
      );
    } on UnverifiedEmailException {
      return (
        user: _authService.currentUser ?? _dummyUser(),
        failure: const UnverifiedEmailFailure(),
      );
    } on AuthException catch (e) {
      return (
        user: _dummyUser(),
        failure: AuthFailure(e.message),
      );
    } catch (e) {
      return (
        user: _dummyUser(),
        failure: UnexpectedFailure(e.toString()),
      );
    }
  }

  // ── Sign up ───────────────────────────────────────────────────────────────

  @override
  Future<({User? user, Failure? failure})> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      return (user: user, failure: null);
    } on EmailAlreadyInUseException {
      return (user: null, failure: const EmailAlreadyInUseFailure());
    } on AuthException catch (e) {
      return (user: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (user: null, failure: UnexpectedFailure(e.toString()));
    }
  }

  // ── Sign out ──────────────────────────────────────────────────────────────

  @override
  Future<Failure?> signOut() async {
    try {
      await _authService.signOut();
      return null;
    } catch (e) {
      return null; // Silently succeed for sign-out
    }
  }

  // ── Password reset ────────────────────────────────────────────────────────

  @override
  Future<Failure?> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return null;
    } on AuthException catch (e) {
      return AuthFailure(e.message);
    } catch (e) {
      return UnexpectedFailure(e.toString());
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────
  // Returns a placeholder when a User object is required but doesn't exist
  User _dummyUser() => throw UnimplementedError('No user available');
}
