import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification_preferences.dart';
import 'budget_settings.dart';
import 'financial_goal.dart';
import 'app_preferences.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? fullName,
    String? avatarUrl,
    
    @Default('KRW') String primaryCurrency,
    @Default([]) List<String> secondaryCurrencies,
    @Default('Asia/Seoul') String timezone,
    @Default('ko') String locale,
    @Default('KR') String countryCode,
    
    @Default({}) Map<String, dynamic> purchasedFeatures,
    
    required NotificationPreferences notificationPreferences,
    required BudgetSettings defaultBudgetSettings,
    @Default([]) List<FinancialGoal> financialGoals,
    required AppPreferences appPreferences,
    
    @Default(false) bool profileCompleted,
    @Default(false) bool onboardingCompleted,
    
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  // Custom fromJson for Supabase JSONB fields
  factory UserProfile.fromSupabase(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      
      primaryCurrency: json['primary_currency'] as String? ?? 'KRW',
      secondaryCurrencies: (json['secondary_currencies'] as List<dynamic>?)
          ?.map((e) => e as String).toList() ?? [],
      timezone: json['timezone'] as String? ?? 'Asia/Seoul',
      locale: json['locale'] as String? ?? 'ko',
      countryCode: json['country_code'] as String? ?? 'KR',
      
      purchasedFeatures: json['purchased_features'] as Map<String, dynamic>? ?? {},
      
      notificationPreferences: json['notification_preferences'] != null 
          ? NotificationPreferences.fromJson(json['notification_preferences'] as Map<String, dynamic>)
          : NotificationPreferences.defaultSettings(),
      
      defaultBudgetSettings: json['default_budget_settings'] != null
          ? BudgetSettings.fromJson(json['default_budget_settings'] as Map<String, dynamic>)
          : BudgetSettings.defaultSettings(),
      
      financialGoals: json['financial_goals'] != null
          ? (json['financial_goals'] as List<dynamic>)
              .map((goal) => FinancialGoal.fromJson(goal as Map<String, dynamic>))
              .toList()
          : [],
      
      appPreferences: json['app_preferences'] != null
          ? AppPreferences.fromJson(json['app_preferences'] as Map<String, dynamic>)
          : AppPreferences.defaultSettings(),
      
      profileCompleted: json['profile_completed'] as bool? ?? false,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

// Extension for methods and computed properties
extension UserProfileExtension on UserProfile {
  // Convert to format suitable for Supabase updates
  Map<String, dynamic> toSupabaseJson() {
    return {
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'primary_currency': primaryCurrency,
      'secondary_currencies': secondaryCurrencies,
      'timezone': timezone,
      'locale': locale,
      'country_code': countryCode,
      'purchased_features': purchasedFeatures,
      'notification_preferences': notificationPreferences.toJson(),
      'default_budget_settings': defaultBudgetSettings.toJson(),
      'financial_goals': financialGoals.map((goal) => goal.toJson()).toList(),
      'app_preferences': appPreferences.toJson(),
      'profile_completed': profileCompleted,
      'onboarding_completed': onboardingCompleted,
    };
  }

  // Feature limit getters
  int get assetLimit {
    const baseLimit = 2;
    final purchased = (purchasedFeatures['assets'] as Map<String, dynamic>?)?['count'] as int? ?? 0;
    return baseLimit + purchased;
  }
  
  int get categoryLimit {
    const baseLimit = 5;
    final purchased = (purchasedFeatures['categories'] as Map<String, dynamic>?)?['count'] as int? ?? 0;
    return baseLimit + purchased;
  }
  
  int get recurringTransactionLimit {
    const baseLimit = 2;
    final purchased = (purchasedFeatures['recurring_transactions'] as Map<String, dynamic>?)?['count'] as int? ?? 0;
    return baseLimit + purchased;
  }
  
  bool get hasUserSharing {
    return (purchasedFeatures['user_sharing'] as Map<String, dynamic>?)?['enabled'] as bool? ?? false;
  }
  
  bool get hasDashboardCharts {
    return (purchasedFeatures['dashboard_charts'] as Map<String, dynamic>?)?['enabled'] as bool? ?? false;
  }
  
  // Helper methods
  bool canCreateAsset(int currentAssetCount) => currentAssetCount < assetLimit;
  bool canCreateCategory(int currentCategoryCount) => currentCategoryCount < categoryLimit;
  bool canCreateRecurringTransaction(int currentRecurringCount) => currentRecurringCount < recurringTransactionLimit;
}