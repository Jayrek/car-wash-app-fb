import 'package:car_wash_app/core/widgets/elevated_button_car_wash.dart';
import 'package:car_wash_app/core/widgets/textformfield_car_wash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.removeCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormFieldCarWash(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Please enter your email';
                      if (!email.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormFieldCarWash(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: authState.obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () => ref
                          .read(authNotifierProvider.notifier)
                          .toggleObscurePassword(),
                      icon: Icon(
                        authState.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      final password = value?.trim() ?? '';
                      if (password.isEmpty) return 'Please enter your password';
                      if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonCarWash(
                    onPressed: () async {
                      final isValid =
                          _formKey.currentState?.validate() ?? false;
                      if (!isValid) return;

                      FocusScope.of(context).unfocus();
                      _signInWithEmailAndPassword(context, ref);
                    },

                    child: _buttonWidgetState(authState.isSigningIn, 'Sign In'),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButtonCarWash(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      _signInWithGoogle(context, ref);
                    },
                    child: _buttonWidgetState(
                      authState.isGoogleSigningIn,
                      'Sign-In with Google',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonWidgetState(bool isLoading, String label) {
    return isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);
  }

  // sign in with email and password
  Future<void> _signInWithEmailAndPassword(
    BuildContext context,
    WidgetRef ref,
  ) async => ref
      .read(authNotifierProvider.notifier)
      .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

  // sign in with google
  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }
}
