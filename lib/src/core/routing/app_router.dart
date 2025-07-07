import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:seulgiful/src/features/auth/presentation/controllers/auth_providers.dart';
import 'package:seulgiful/src/features/auth/presentation/screens/login_screen.dart';
import 'package:seulgiful/src/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'app_router.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;
  
  @override
  void build() {
    // Listen to auth state changes
    ref.listen(authStateProvider, (previous, next) {
      _routerListener?.call();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}

@riverpod
GoRouter router(Ref ref) {
  final routerNotifier = ref.watch(routerNotifierProvider.notifier);
  
  return GoRouter(
    refreshListenable: routerNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStateProvider);

      return authState.when(
        data: (auth) {
          final isAuthenticated = auth.isAuthenticated;
          final isGoingToLogin = state.matchedLocation == '/login';

          log('Auth check: isAuthenticated=$isAuthenticated, location=${state.matchedLocation}');

          if (!isAuthenticated && !isGoingToLogin) {
            log('Redirecting to login - not authenticated');
            return '/login';
          }

          if (isAuthenticated && isGoingToLogin) {
            log('Redirecting to home - already authenticated');
            return '/';
          }

          return null;
        },
        loading: () {
          log('Auth state loading');
          return null;
        },
        error: (error, stackTrace) {
          log('Auth error: $error');
          return '/login';
        },
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
    ],
  );
}