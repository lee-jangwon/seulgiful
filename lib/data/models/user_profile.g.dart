// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  primaryCurrency: json['primaryCurrency'] as String? ?? 'KRW',
  secondaryCurrencies:
      (json['secondaryCurrencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  timezone: json['timezone'] as String? ?? 'Asia/Seoul',
  locale: json['locale'] as String? ?? 'ko',
  countryCode: json['countryCode'] as String? ?? 'KR',
  purchasedFeatures:
      json['purchasedFeatures'] as Map<String, dynamic>? ?? const {},
  notificationPreferences: NotificationPreferences.fromJson(
    json['notificationPreferences'] as Map<String, dynamic>,
  ),
  defaultBudgetSettings: BudgetSettings.fromJson(
    json['defaultBudgetSettings'] as Map<String, dynamic>,
  ),
  financialGoals:
      (json['financialGoals'] as List<dynamic>?)
          ?.map((e) => FinancialGoal.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  appPreferences: AppPreferences.fromJson(
    json['appPreferences'] as Map<String, dynamic>,
  ),
  profileCompleted: json['profileCompleted'] as bool? ?? false,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'primaryCurrency': instance.primaryCurrency,
      'secondaryCurrencies': instance.secondaryCurrencies,
      'timezone': instance.timezone,
      'locale': instance.locale,
      'countryCode': instance.countryCode,
      'purchasedFeatures': instance.purchasedFeatures,
      'notificationPreferences': instance.notificationPreferences,
      'defaultBudgetSettings': instance.defaultBudgetSettings,
      'financialGoals': instance.financialGoals,
      'appPreferences': instance.appPreferences,
      'profileCompleted': instance.profileCompleted,
      'onboardingCompleted': instance.onboardingCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
