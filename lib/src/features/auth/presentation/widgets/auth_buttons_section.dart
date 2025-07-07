import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seulgiful/src/features/auth/presentation/controllers/auth_providers.dart';
import 'package:seulgiful/src/features/auth/presentation/widgets/oauth_button.dart';

class AuthButtonsSection extends ConsumerWidget {
  const AuthButtonsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '간편하게 시작하기',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withAlpha(180),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OauthButton(
          provider: 'Google',
          icon: Icons.chat,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          onPressed: ref.read(authStateProvider.notifier).signInWithGoogle,
        ),
        const SizedBox(height: 6),
        OauthButton(
          provider: 'Kakao',
          icon: Icons.chat,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          onPressed: ref.read(authStateProvider.notifier).signInWithKakao,
        ),
        const SizedBox(height: 6),
        OauthButton(
          provider: 'Test',
          icon: Icons.person,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          onPressed: ref.read(authStateProvider.notifier).signInAsTestUser,
        ),
      ],
    );
  }
}
