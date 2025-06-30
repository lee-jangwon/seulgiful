import 'package:test/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Dotenv loaded', () {
    test('should load .env file', () {
      dotenv.load(fileName: '.env');
      expect(dotenv.env['SUPABASE_URL'], isNotNull);
      expect(dotenv.env['SUPABASE_ANON_KEY'], isNotNull);
    });
  });

  group('Supabase client', () {
    test('should initialize supabase client', () {
      final url = dotenv.env['SUPABASE_URL']!;
      final anonKey = dotenv.env['SUPABASE_ANON_KEY']!;
      final client = Supabase.initialize(url: url, anonKey: anonKey);

      expect(client, isNotNull);
    });
  });
}