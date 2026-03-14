import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../core/error/exceptions.dart';

/// Low-level Supabase auth calls. All methods throw [AuthException] subtypes
/// on failure so the repository can map them to Failures.
class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  SupabaseClient get client => _client;

  // ── Current user ──────────────────────────────────────────────────────────

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isLoggedIn => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ── Sign up ───────────────────────────────────────────────────────────────

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          if (phone != null) 'phone': phone,
        },
      );
      final user = response.user;
      if (user == null) throw const AuthException(message: 'Sign up failed.');
      return user;
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      if (e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('already in use')) {
        throw const EmailAlreadyInUseException();
      }
      throw AuthException(message: e.message, code: e.statusCode.toString(), original: e);
    } catch (e) {
      throw AuthException(message: e.toString(), original: e);
    }
  }

  // ── Sign in ───────────────────────────────────────────────────────────────

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw const InvalidCredentialsException();
      return user;
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 422) {
        throw const InvalidCredentialsException();
      }
      throw AuthException(message: e.message, original: e);
    } catch (e) {
      throw AuthException(message: e.toString(), original: e);
    }
  }

  // ── Sign out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      // Ignore sign out errors — local state is cleared either way
    }
  }

  // ── Password reset ────────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message, original: e);
    } catch (e) {
      throw AuthException(message: e.toString(), original: e);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message, original: e);
    } catch (e) {
      throw AuthException(message: e.toString(), original: e);
    }
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<void> updateProfile({String? fullName, String? phone}) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
          },
        ),
      );
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message, original: e);
    } catch (e) {
      throw AuthException(message: e.toString(), original: e);
    }
  }
}
