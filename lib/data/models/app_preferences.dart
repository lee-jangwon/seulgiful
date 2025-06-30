import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preferences.freezed.dart';
part 'app_preferences.g.dart';

@freezed
abstract class AppPreferences with _$AppPreferences {
  const factory AppPreferences({
    required bool currencyConversionWarnings,
    required bool quickAddEnabled,
    required String defaultTransactionTime,
  }) = _AppPreferences;

  factory AppPreferences.fromJson(Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  factory AppPreferences.defaultSettings() => const AppPreferences(
    currencyConversionWarnings: true,
    quickAddEnabled: true,
    defaultTransactionTime: 'current',
  );
}