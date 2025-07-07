import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required WeeklySummarySettings weeklySummary,
    required DailyReminderSettings dailyReminder,
    required BudgetAlertSettings budgetAlerts,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  // Default factory for new users
  factory NotificationPreferences.defaultSettings() => const NotificationPreferences(
    weeklySummary: WeeklySummarySettings(
      enabled: true,
      dayOfWeek: 'sunday',
     time: '18:00',
    ),
    dailyReminder: DailyReminderSettings(
      enabled: true,
      time: '21:00',
    ),
    budgetAlerts: BudgetAlertSettings(
      enabled: true,
      weeklyThreshold: 80,
      monthlyThreshold: 80,
    ),
  );
}

@freezed
abstract class WeeklySummarySettings with _$WeeklySummarySettings {
  const factory WeeklySummarySettings({
    required bool enabled,
    required String dayOfWeek,
    required String time,
  }) = _WeeklySummarySettings;

  factory WeeklySummarySettings.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummarySettingsFromJson(json);
}

@freezed
abstract class DailyReminderSettings with _$DailyReminderSettings {
  const factory DailyReminderSettings({
    required bool enabled,
    required String time,
  }) = _DailyReminderSettings;

  factory DailyReminderSettings.fromJson(Map<String, dynamic> json) =>
      _$DailyReminderSettingsFromJson(json);
}

@freezed
abstract class BudgetAlertSettings with _$BudgetAlertSettings {
  const factory BudgetAlertSettings({
    required bool enabled,
    required int weeklyThreshold,
    required int monthlyThreshold,
  }) = _BudgetAlertSettings;

  factory BudgetAlertSettings.fromJson(Map<String, dynamic> json) =>
      _$BudgetAlertSettingsFromJson(json);
}