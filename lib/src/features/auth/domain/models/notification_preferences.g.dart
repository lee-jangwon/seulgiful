// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  weeklySummary: WeeklySummarySettings.fromJson(
    json['weeklySummary'] as Map<String, dynamic>,
  ),
  dailyReminder: DailyReminderSettings.fromJson(
    json['dailyReminder'] as Map<String, dynamic>,
  ),
  budgetAlerts: BudgetAlertSettings.fromJson(
    json['budgetAlerts'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'weeklySummary': instance.weeklySummary,
  'dailyReminder': instance.dailyReminder,
  'budgetAlerts': instance.budgetAlerts,
};

_WeeklySummarySettings _$WeeklySummarySettingsFromJson(
  Map<String, dynamic> json,
) => _WeeklySummarySettings(
  enabled: json['enabled'] as bool,
  dayOfWeek: json['dayOfWeek'] as String,
  time: json['time'] as String,
);

Map<String, dynamic> _$WeeklySummarySettingsToJson(
  _WeeklySummarySettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'dayOfWeek': instance.dayOfWeek,
  'time': instance.time,
};

_DailyReminderSettings _$DailyReminderSettingsFromJson(
  Map<String, dynamic> json,
) => _DailyReminderSettings(
  enabled: json['enabled'] as bool,
  time: json['time'] as String,
);

Map<String, dynamic> _$DailyReminderSettingsToJson(
  _DailyReminderSettings instance,
) => <String, dynamic>{'enabled': instance.enabled, 'time': instance.time};

_BudgetAlertSettings _$BudgetAlertSettingsFromJson(Map<String, dynamic> json) =>
    _BudgetAlertSettings(
      enabled: json['enabled'] as bool,
      weeklyThreshold: (json['weeklyThreshold'] as num).toInt(),
      monthlyThreshold: (json['monthlyThreshold'] as num).toInt(),
    );

Map<String, dynamic> _$BudgetAlertSettingsToJson(
  _BudgetAlertSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'weeklyThreshold': instance.weeklyThreshold,
  'monthlyThreshold': instance.monthlyThreshold,
};
