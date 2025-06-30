import 'package:seulgiful/data/models/user_profile.dart';
import 'package:seulgiful/data/models/notification_preferences.dart';
import 'package:seulgiful/data/models/budget_settings.dart';
import 'package:seulgiful/data/models/financial_goal.dart';
import 'package:seulgiful/data/models/app_preferences.dart';

class TestData {
  // Sample JSON data as it would come from Supabase
  static Map<String, dynamic> get sampleSupabaseProfileJson => {
    'id': 'test-user-id-123',
    'email': 'test@example.com',
    'full_name': '김철수',
    'avatar_url': 'https://example.com/avatar.jpg',
    'primary_currency': 'KRW',
    'secondary_currencies': ['USD', 'EUR'],
    'timezone': 'Asia/Seoul',
    'locale': 'ko',
    'country_code': 'KR',
    'purchased_features': {
      'assets': {'count': 3, 'purchased_at': '2025-01-15T10:30:00Z'},
      'user_sharing': {'enabled': true, 'purchased_at': '2025-02-01T09:15:00Z'},
    },
    'notification_preferences': {
      'weeklySummary': {
        'enabled': true,
        'dayOfWeek': 'sunday',
        'time': '18:00',
      },
      'dailyReminder': {
        'enabled': false,
        'time': '20:00',
      },
      'budgetAlerts': {
        'enabled': true,
        'weeklyThreshold': 75,
        'monthlyThreshold': 85,
      },
    },
    'default_budget_settings': {
      'weeklyBudget': 150000.0,
      'monthlyBudget': 500000.0,
      'budgetStartDay': 'monday',
    },
    'financial_goals': [
      {
        'id': 'goal-1',
        'type': 'save_amount',
        'amount': 1000000.0,
        'currency': 'KRW',
        'targetDate': '2025-12-31T00:00:00Z',
        'createdAt': '2025-01-01T00:00:00Z',
      },
      {
        'id': 'goal-2',
        'type': 'spend_less_than',
        'amount': 300000.0,
        'currency': 'KRW',
        'period': 'monthly',
        'createdAt': '2025-01-01T00:00:00Z',
      },
    ],
    'app_preferences': {
      'currencyConversionWarnings': true,
      'quickAddEnabled': true,
      'defaultTransactionTime': 'current',
    },
    'profile_completed': true,
    'onboarding_completed': true,
    'created_at': '2025-01-01T00:00:00Z',
    'updated_at': '2025-01-15T12:00:00Z',
  };

  // Minimal JSON for testing defaults
  static Map<String, dynamic> get minimalSupabaseProfileJson => {
    'id': 'minimal-user-id',
    'email': 'minimal@example.com',
    'created_at': '2025-01-01T00:00:00Z',
    'updated_at': '2025-01-01T00:00:00Z',
  };

  // Sample UserProfile object
  static UserProfile get sampleUserProfile => UserProfile.fromSupabase(sampleSupabaseProfileJson);

  // Sample FinancialGoal objects
  static FinancialGoal get savingsGoal => FinancialGoal(
    id: 'savings-goal-1',
    type: 'save_amount',
    amount: 1000000,
    currency: 'KRW',
    targetDate: null,
    createdAt: DateTime.now(),
  );

  static FinancialGoal get spendingGoal => FinancialGoal(
    id: 'spending-goal-1',
    type: 'spend_less_than',
    amount: 300000,
    currency: 'KRW',
    period: 'monthly',
    createdAt: DateTime.now(),
  );
}