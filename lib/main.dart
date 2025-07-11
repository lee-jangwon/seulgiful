import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seulgiful/src/core/routing/app_router.dart';
import 'package:seulgiful/src/core/theme/base_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load();
  final SUPABASE_URL = dotenv.env["SUPABASE_URL"]!;
  final SUPABASE_ANON_KEY = dotenv.env["SUPABASE_ANON_KEY"]!;

  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'Seulgiful',
      theme: kBaseTheme,
    );
  }
}
