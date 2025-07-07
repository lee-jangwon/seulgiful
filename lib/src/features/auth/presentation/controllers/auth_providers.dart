import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seulgiful/src/core/api/supabase_provider.dart';


part 'auth_providers.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Stream<AuthStateModel> build() {
    final supabase = ref.read(supabaseClientProvider);

    return supabase.auth.onAuthStateChange.map((data) {
      return AuthStateModel(user: data.session?.user, session: data.session);
    });
  }

  Future<void> signInWithGoogle() async {
    final supabase = ref.read(supabaseClientProvider);
    log('Signing in with Google not yet implemented.');
    // await supabase.auth.signInWithOAuth(OAuthProvider.google, redirectTo: 'com.rapportlycollective.seulgiful://login-callback/');
  }

  Future<void> signInWithKakao() async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.signInWithOAuth(
      OAuthProvider.kakao,
      redirectTo: 'com.rapportlycollective.seulgiful://login-callback/',
    );
  }

  // For debugging purposes only
  Future<void> signInAsTestUser() async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.auth.signInWithPassword(
        email: 'test@test.com',
        password: 'testing12!@#',
      );
    } on AuthException catch (e) {
      log('AuthException: ${e.code}, ${e.message}');
      if (e.code == 'invalid_credentials') {
        await _createTestUser();
      } else {
        rethrow;
      }
    }
  }

  Future<void> _createTestUser() async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      final response = await supabase.auth.signUp(
        email: 'test@test.com',
        password: 'testing12!@#',
        data: {
          'full_name': '테스트 사용자',
          'avatar_url': 'https://ui-avatars.com/api/?name=Test+User&background=0D8ABC&color=fff',
        },
      );
      
      if (response.user != null) {
        log('Test user created and signed in successfully');
      } else {
        log('Test user creation failed - no user returned');
      }
    } on AuthException catch (e) {
      log('Error creating test user: ${e.message}');
      
      // If user already exists, try to sign in again
      if (e.message.contains('User already registered')) {
        log('User already exists, attempting sign in...');
        await supabase.auth.signInWithPassword(
          email: 'test@test.com',
          password: 'testing12!@#',
        );
      } else {
        rethrow;
      }
    } catch (e) {
      log('Unexpected error creating test user: $e');
      rethrow;
    }
  }
  Future<void> signOut() async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.signOut();
  }
}

class AuthStateModel {
  final User? user;
  final Session? session;

  AuthStateModel({this.user, this.session});

  bool get isAuthenticated => user != null && session != null;
}
