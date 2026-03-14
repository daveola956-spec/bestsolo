import 'package:supabase_flutter/supabase_flutter.dart' show User;
import '../core/error/failures.dart';

/// Contract for auth operations.
abstract interface class AuthRepository {
  Future<({User user, Failure? failure})> signIn({
    required String email,
    required String password,
  });

  Future<({User? user, Failure? failure})> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  Future<Failure?> signOut();

  Future<Failure?> sendPasswordResetEmail(String email);

  User? get currentUser;
  bool get isLoggedIn;

  Stream<User?> get userStream;
}
