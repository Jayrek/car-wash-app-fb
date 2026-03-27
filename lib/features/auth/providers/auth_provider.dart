import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/firebase_auth_service.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  FirebaseAuthService get _authService => ref.read(firebaseAuthServiceProvider);

  @override
  AuthState build() => AuthState.initial();

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSigningIn: true, errorMessage: null);
    try {
      await _authService.signInWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );
    } catch (e) {
      state = state.copyWith(isSigningIn: false, errorMessage: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isGoogleSigningIn: true, errorMessage: null);
    // try {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // } catch (e) {
    state = state.copyWith(
      isGoogleSigningIn: false,
      errorMessage: 'Google sign-in is not connected yet.',
    );
    // }
  }

  Future<void> signOut() async {
    state = state.copyWith(isSigningOut: true, errorMessage: null);
    try {
      await _authService.signOut();
    } catch (e) {
      state = state.copyWith(isSigningOut: false, errorMessage: e.toString());
    }
  }
}
