import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seulgiful/src/features/auth/presentation/controllers/auth_providers.dart';
import 'package:seulgiful/src/features/auth/presentation/widgets/auth_buttons_section.dart';
import 'package:seulgiful/src/features/auth/presentation/widgets/login_loading_overlay.dart';
import 'package:seulgiful/src/features/auth/presentation/widgets/welcome_section.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 60),
                WelcomeSection(),
                SizedBox(height: 80),
                if (!ref.watch(authStateProvider).isLoading)
                  AuthButtonsSection()
                else
                  LoginLoadingOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
