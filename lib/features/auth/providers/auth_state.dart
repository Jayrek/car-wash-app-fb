import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default(false) bool isSigningIn,
    @Default(false) bool isGoogleSigningIn,
    @Default(false) bool isSigningOut,
    String? errorMessage,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState();
}
