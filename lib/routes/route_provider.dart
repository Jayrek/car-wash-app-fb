import 'package:car_wash_app/core/constants/user_role_enum.dart';
import 'package:car_wash_app/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/firebase_auth_service.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/customer/screens/customer_dashboard_screen.dart';
import 'app_routes.dart';

part 'route_provider.g.dart';

enum AuthRouteStatus { loading, signedOut, admin, customer }

class AuthRouteState {
  const AuthRouteState({required this.status});

  final AuthRouteStatus status;
}

@riverpod
Stream<AuthRouteState> authRouteState(Ref ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);

  return authService.authStateChanges().asyncMap((user) async {
    final firestoreService = ref.watch(firebaseFirestoreServiceProvider);
    if (user == null) {
      return const AuthRouteState(status: AuthRouteStatus.signedOut);
    }

    final userData = await firestoreService.getUser(user.uid);
    if (userData?.role == UserRoleEnum.admin.name) {
      return const AuthRouteState(status: AuthRouteStatus.admin);
    }
    return const AuthRouteState(status: AuthRouteStatus.customer);
  });
}

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen<AsyncValue<AuthRouteState>>(
      authRouteStateProvider,
      (previous, next) => notifyListeners(),
    );
  }

  final Ref ref;
}

@riverpod
GoRouterRefreshNotifier goRouterRefreshNotifier(Ref ref) {
  ref.keepAlive();
  return GoRouterRefreshNotifier(ref);
}

@riverpod
GoRouter goRouter(Ref ref) {
  ref.keepAlive();
  final refreshNotifier = ref.watch(goRouterRefreshNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.signIn, builder: (_, _) => SignInScreen()),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (_, _) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerDashboard,
        builder: (_, _) => const CustomerDashboardScreen(),
      ),
    ],
    redirect: (_, _) {
      final authState = ref.read(authRouteStateProvider);

      if (authState.isLoading) {
        return AppRoutes.splash;
      }

      return authState.when(
        loading: () => AppRoutes.splash,
        error: (_, _) => AppRoutes.signIn,
        data: (state) {
          switch (state.status) {
            case AuthRouteStatus.loading:
              return AppRoutes.splash;
            case AuthRouteStatus.signedOut:
              return AppRoutes.signIn;
            case AuthRouteStatus.admin:
              return AppRoutes.adminDashboard;
            case AuthRouteStatus.customer:
              return AppRoutes.customerDashboard;
          }
        },
      );
    },
  );
}
