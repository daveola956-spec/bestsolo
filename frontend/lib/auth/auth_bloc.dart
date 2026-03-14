import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;
import 'auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  final SupabaseClient _supabase;

  AuthBloc(this._repo, this._supabase) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
  }

  /// Fetch the user's role from the Supabase users table.
  Future<String> _fetchRole(String userId) async {
    try {
      final row = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      return (row?['role'] as String?) ?? 'customer';
    } catch (_) {
      return 'customer';
    }
  }

  // ── Check session ─────────────────────────────────────────────────────────

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500)); // splash delay
    final user = _repo.currentUser;
    if (user != null) {
      final role = await _fetchRole(user.id);
      emit(AuthAuthenticated(
        userId: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] as String?,
        role: role,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // ── Sign in ───────────────────────────────────────────────────────────────

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionLoading());
    try {
      final result = await _repo.signIn(
        email: event.email,
        password: event.password,
      );
      if (result.failure != null) {
        emit(AuthFailureState(result.failure!.message));
      } else {
        final role = await _fetchRole(result.user.id);
        emit(AuthAuthenticated(
          userId: result.user.id,
          email: result.user.email ?? '',
          fullName: result.user.userMetadata?['full_name'] as String?,
          role: role,
        ));
      }
    } catch (e) {
      emit(AuthFailureState('An unexpected error occurred. Please try again.'));
    }
  }

  // ── Sign up ───────────────────────────────────────────────────────────────

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionLoading());
    try {
      final result = await _repo.signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        phone: event.phone,
      );
      if (result.failure != null) {
        emit(AuthFailureState(result.failure!.message));
      } else {
        emit(AuthRegistered(requiresEmailVerification: true));
      }
    } catch (e) {
      emit(AuthFailureState('An unexpected error occurred. Please try again.'));
    }
  }

  // ── Sign out ──────────────────────────────────────────────────────────────

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repo.signOut();
    emit(AuthUnauthenticated());
  }

  // ── Password reset ────────────────────────────────────────────────────────

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionLoading());
    final failure = await _repo.sendPasswordResetEmail(event.email);
    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else {
      emit(AuthPasswordResetSent(event.email));
    }
  }
}
