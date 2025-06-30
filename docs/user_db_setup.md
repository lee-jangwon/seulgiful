# User & Profile Model Documentation
## Expense Tracking App with Flutter & Supabase

### Table of Contents
1. [Overview](#overview)
2. [Database Architecture](#database-architecture)
3. [Social Authentication Setup](#social-authentication-setup)
4. [Profile Model Structure](#profile-model-structure)
5. [Database Triggers & Functions](#database-triggers-- Check if trigger function has security definer
SELECT proname, prosecdef 
FROM pg_proc 
WHERE proname = 'handle_new_user';

-- Check recent errors in logs
SELECT * FROM pg_stat_statements 
WHERE query LIKE '%handle_new_user%' 
ORDER BY last_exec_time DESC LIMIT 5;
```

**Manual Profile Creation** (for recovery):
```sql
-- Manually create missing profile
INSERT INTO public.profiles (
  id, email, full_name, primary_currency, timezone, locale, country_code
) VALUES (
  'user-id-here',
  'user@example.com',
  'User Name',
  'KRW',
  'Asia/Seoul',
  'ko',
  'KR'
) ON CONFLICT (id) DO NOTHING;
```

#### 2. RLS Policies Blocking Access

**Symptoms**: Users cannot read or update their own profiles.

**Debugging**:
```sql
-- Test RLS policies manually
SET LOCAL "request.jwt.claims" = '{"sub": "user-id-here"}';
SELECT * FROM public.profiles WHERE id = 'user-id-here';

-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'profiles';

-- List all policies on profiles table
SELECT * FROM pg_policies WHERE tablename = 'profiles';
```

**Solutions**:
```sql
-- Grant proper permissions
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- Verify auth.uid() function works
SELECT auth.uid();

-- Recreate policies if needed
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" 
ON public.profiles 
FOR SELECT 
TO authenticated 
USING ((SELECT auth.uid()) = id);
```

#### 3. OAuth Deep Link Issues

**Symptoms**: OAuth callback doesn't redirect properly to the app.

**Common Issues**:
- Incorrect redirect URL configuration
- Deep link not properly configured in mobile app
- URL scheme conflicts

**Solutions**:

1. **Verify Redirect URLs in Supabase Dashboard**:
   - Development: `com.yourapp.expense://login-callback/`
   - Production: `com.yourapp.expense://login-callback/`

2. **Test Deep Links**:
   ```bash
   # Android
   adb shell am start \
     -W -a android.intent.action.VIEW \
     -d "com.yourapp.expense://login-callback/?access_token=test" \
     com.yourapp.expense

   # iOS Simulator
   xcrun simctl openurl booted "com.yourapp.expense://login-callback/?access_token=test"
   ```

3. **Flutter Deep Link Handling**:
   ```dart
   // lib/main.dart
   void main() {
     runApp(MyApp());
     
     // Handle deep links when app is already running
     _linkStream = linkStream.listen((String link) {
       _handleIncomingLink(link);
     });
   }
   
   void _handleIncomingLink(String link) {
     if (link.contains('login-callback')) {
       // Extract tokens and complete authentication
       final uri = Uri.parse(link);
       final accessToken = uri.queryParameters['access_token'];
       final refreshToken = uri.queryParameters['refresh_token'];
       
       if (accessToken != null && refreshToken != null) {
         // Complete authentication flow
         Supabase.instance.client.auth.setSession(
           Session(
             accessToken: accessToken,
             refreshToken: refreshToken,
           ),
         );
       }
     }
   }
   ```

#### 4. Feature Limit Calculations Incorrect

**Symptoms**: Users can create more items than their feature limits allow.

**Debugging**:
```dart
// Add logging to feature checking
bool canCreateAsset() {
  final currentCount = getCurrentAssetCount();
  final limit = getFeatureLimit(FeatureLimits.assets);
  
  print('Current assets: $currentCount, Limit: $limit');
  
  return currentCount < limit;
}

// Verify purchased features data
void debugPurchasedFeatures() {
  final profile = getCurrentProfile();
  print('Purchased features: ${profile.purchasedFeatures}');
  
  final assetCount = profile.purchasedFeatures['assets']?['count'] ?? 0;
  print('Purchased asset count: $assetCount');
}
```

**Solutions**:
1. **Verify JSON Structure**: Ensure purchased features follow the correct format
2. **Add Validation**: Validate feature purchases on both client and server
3. **Implement Server-Side Checks**: Use database constraints or triggers for limits

#### 5. Account Linking Creates Duplicate Profiles

**Symptoms**: Users have multiple profiles when linking social accounts.

**Prevention**:
```sql
-- Update trigger function to handle account linking
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $
BEGIN
  -- Use ON CONFLICT to prevent duplicates during account linking
  INSERT INTO public.profiles (
    id, email, full_name, avatar_url,
    -- ... other fields
  ) VALUES (
    NEW.id, NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'avatar_url',
    -- ... other values
  ) ON CONFLICT (id) DO UPDATE SET
    -- Update with new metadata if available
    full_name = COALESCE(EXCLUDED.full_name, profiles.full_name),
    avatar_url = COALESCE(EXCLUDED.avatar_url, profiles.avatar_url),
    updated_at = NOW();
  
  RETURN NEW;
END;
$;
```

#### 6. Currency Conversion and Localization Issues

**Symptoms**: Incorrect currency display or timezone handling.

**Solutions**:
```dart
// lib/utils/currency_utils.dart
class CurrencyUtils {
  static String formatCurrency(double amount, String currencyCode, String locale) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: _getCurrencySymbol(currencyCode),
    );
    return formatter.format(amount);
  }
  
  static String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'KRW':
        return '₩';
      case 'USD':
        return '\functions)
6. [Row Level Security (RLS)](#row-level-security-rls)
7. [Flutter Integration](#flutter-integration)
8. [Implementation Guide](#implementation-guide)
9. [Testing Strategy](#testing-strategy)
10. [Troubleshooting](#troubleshooting)

---

## Overview

This documentation outlines the user and profile model architecture for an expense tracking app built with Flutter and Supabase. The system implements a pay-per-feature SaaS model where users can purchase additional capabilities permanently (not subscription-based).

### Key Features
- **Social Authentication**: Google and Kakao OAuth login
- **Account Linking**: Users can link multiple social accounts
- **Progressive Profile Setup**: Users can start using the app immediately
- **Pay-per-Feature Model**: Purchase additional features permanently
- **Multi-currency Support**: Primary currency with conversion handling
- **Notification Preferences**: Customizable alerts and reminders
- **Financial Goals**: Simple saving and spending goals

---

## Database Architecture

### Core Tables Structure

#### 1. auth.users (Supabase Managed)
This table is automatically managed by Supabase Auth and contains:
- `id` (UUID, primary key)
- `email` (text)
- `phone` (text, nullable)
- `email_confirmed_at` (timestamp)
- `confirmation_token` (text)
- `recovery_token` (text)
- `email_change_token_new` (text)
- `email_change` (text)
- `last_sign_in_at` (timestamp)
- `raw_app_meta_data` (jsonb)
- `raw_user_meta_data` (jsonb)
- `is_super_admin` (boolean)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 2. public.profiles (Custom Table)
This table extends user data and is automatically created via triggers:

```sql
CREATE TABLE public.profiles (
  -- Identity
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  
  -- Localization & Preferences
  primary_currency TEXT NOT NULL DEFAULT 'KRW',
  secondary_currencies TEXT[] DEFAULT '{}',
  timezone TEXT NOT NULL DEFAULT 'Asia/Seoul',
  locale TEXT NOT NULL DEFAULT 'ko',
  country_code TEXT NOT NULL DEFAULT 'KR',
  
  -- Feature Purchases (Pay-per-feature model)
  purchased_features JSONB NOT NULL DEFAULT '{}',
  
  -- Notification Preferences
  notification_preferences JSONB NOT NULL DEFAULT '{
    "weekly_summary": {"enabled": true, "day_of_week": "sunday", "time": "18:00"},
    "daily_reminder": {"enabled": true, "time": "21:00"},
    "budget_alerts": {"enabled": true, "weekly_threshold": 80, "monthly_threshold": 80}
  }',
  
  -- Budget Settings
  default_budget_settings JSONB NOT NULL DEFAULT '{
    "weekly_budget": null,
    "monthly_budget": null,
    "budget_start_day": "monday"
  }',
  
  -- Financial Goals (Simple structure)
  financial_goals JSONB NOT NULL DEFAULT '[]',
  
  -- App Preferences
  app_preferences JSONB NOT NULL DEFAULT '{
    "currency_conversion_warnings": true,
    "quick_add_enabled": true,
    "default_transaction_time": "current"
  }',
  
  -- Profile State
  profile_completed BOOLEAN NOT NULL DEFAULT false,
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## Social Authentication Setup

### 1. Configure OAuth Providers in Supabase Dashboard

#### Google OAuth Configuration
1. Navigate to **Authentication → Providers** in your Supabase dashboard
2. Enable Google provider
3. Add your Google OAuth credentials:
   - Client ID
   - Client Secret
4. Set redirect URLs:
   - Development: `com.yourapp.expense://login-callback/`
   - Production: `com.yourapp.expense://login-callback/`

#### Kakao OAuth Configuration
1. Enable Kakao provider in the dashboard
2. Configure Kakao OAuth app settings
3. Add redirect URLs following Kakao's requirements
4. Set proper scopes for email and profile access

### 2. Flutter Deep Link Configuration

#### Android Configuration (`android/app/src/main/AndroidManifest.xml`)
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">
    
    <!-- Standard Flutter configuration -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- OAuth callback configuration -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="com.yourapp.expense" />
    </intent-filter>
</activity>
```

#### iOS Configuration (`ios/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourapp.expense</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.yourapp.expense</string>
        </array>
    </dict>
</array>
```

---

## Profile Model Structure

### Feature Purchase System

The `purchased_features` JSONB field stores feature ownership:

```json
{
  "assets": {
    "count": 10,
    "purchased_at": "2025-01-15T10:30:00Z"
  },
  "categories": {
    "count": 15,
    "purchased_at": "2025-01-20T14:20:00Z"
  },
  "user_sharing": {
    "enabled": true,
    "purchased_at": "2025-02-01T09:15:00Z"
  },
  "dashboard_charts": {
    "enabled": true,
    "purchased_at": "2025-02-10T16:45:00Z"
  },
  "recurring_transactions": {
    "count": 8,
    "purchased_at": "2025-02-15T11:30:00Z"
  }
}
```

### Base Feature Limits (App Constants)
```dart
// These are constants in your Flutter app, not stored in the database
class FeatureLimits {
  static const int baseAssetLimit = 2;
  static const int baseCategoryLimit = 5;
  static const int baseRecurringLimit = 2;
  
  // Feature types
  static const String assets = 'assets';
  static const String categories = 'categories';
  static const String userSharing = 'user_sharing';
  static const String dashboardCharts = 'dashboard_charts';
  static const String recurringTransactions = 'recurring_transactions';
}
```

### Financial Goals Structure

Simple goal types stored in the `financial_goals` JSONB array:

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "type": "save_amount",
    "amount": 1000000,
    "currency": "KRW",
    "target_date": "2025-12-31",
    "created_at": "2025-01-15T10:30:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "type": "spend_less_than",
    "amount": 500000,
    "currency": "KRW",
    "period": "monthly",
    "created_at": "2025-01-20T14:20:00Z"
  }
]
```

**Goal Types:**
- `save_amount`: Save X amount by target_date
- `spend_less_than`: Spend less than X in period (weekly/monthly)

---

## Database Triggers & Functions

### 1. Profile Creation Trigger Function

This function automatically creates a profile when a user signs up via OAuth:

```sql
-- Function to handle new user profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  user_email TEXT;
  user_name TEXT;
  user_avatar TEXT;
BEGIN
  -- Extract email from auth.users
  user_email := NEW.email;
  
  -- Safely extract name from raw_user_meta_data
  user_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'name',
    split_part(user_email, '@', 1)
  );
  
  -- Safely extract avatar URL
  user_avatar := COALESCE(
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.raw_user_meta_data->>'picture'
  );
  
  -- Insert profile with smart defaults
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    avatar_url,
    primary_currency,
    timezone,
    locale,
    country_code,
    purchased_features,
    notification_preferences,
    default_budget_settings,
    financial_goals,
    app_preferences,
    profile_completed,
    onboarding_completed,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    user_email,
    user_name,
    user_avatar,
    'KRW', -- Default currency
    'Asia/Seoul', -- Default timezone
    'ko', -- Default locale
    'KR', -- Default country
    '{}', -- Empty purchased features
    '{
      "weekly_summary": {"enabled": true, "day_of_week": "sunday", "time": "18:00"},
      "daily_reminder": {"enabled": true, "time": "21:00"},
      "budget_alerts": {"enabled": true, "weekly_threshold": 80, "monthly_threshold": 80}
    }',
    '{
      "weekly_budget": null,
      "monthly_budget": null,
      "budget_start_day": "monday"
    }',
    '[]', -- Empty financial goals
    '{
      "currency_conversion_warnings": true,
      "quick_add_enabled": true,
      "default_transaction_time": "current"
    }',
    false, -- Profile not completed initially
    false, -- Onboarding not completed
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING; -- Prevent duplicate profiles during account linking
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't prevent user creation
    RAISE LOG 'Error creating profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;
```

### 2. Create the Trigger

```sql
-- Create trigger to automatically create profiles
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW 
  EXECUTE FUNCTION public.handle_new_user();
```

### 3. Updated At Trigger Function

```sql
-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Create trigger for updated_at
CREATE TRIGGER handle_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();
```

---

## Row Level Security (RLS)

### 1. Enable RLS on Profiles Table

```sql
-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
```

### 2. Create RLS Policies

```sql
-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile" 
ON public.profiles 
FOR SELECT 
TO authenticated 
USING ((SELECT auth.uid()) = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile" 
ON public.profiles 
FOR UPDATE 
TO authenticated 
USING ((SELECT auth.uid()) = id)
WITH CHECK ((SELECT auth.uid()) = id);

-- Policy: Prevent direct INSERT (only via trigger)
CREATE POLICY "Prevent direct profile creation" 
ON public.profiles 
FOR INSERT 
TO authenticated 
WITH CHECK (false);

-- Policy: Users can delete their own profile (optional)
CREATE POLICY "Users can delete own profile" 
ON public.profiles 
FOR DELETE 
TO authenticated 
USING ((SELECT auth.uid()) = id);

-- Policy: Service role bypasses RLS for admin operations
-- This allows your backend services to manage profiles if needed
```

### 3. Grant Necessary Permissions

```sql
-- Grant permissions to authenticated users
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- Grant permissions for the trigger function
GRANT INSERT ON public.profiles TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres;
```

---

## Flutter Integration

### 1. Freezed Data Models

```dart
// lib/models/user_profile.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
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
}

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required WeeklySummarySettings weeklySummary,
    required DailyReminderSettings dailyReminder,
    required BudgetAlertSettings budgetAlerts,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

@freezed
class FinancialGoal with _$FinancialGoal {
  const factory FinancialGoal({
    required String id,
    required String type, // 'save_amount' or 'spend_less_than'
    required double amount,
    required String currency,
    String? period, // 'weekly' or 'monthly' for spend_less_than
    DateTime? targetDate, // for save_amount goals
    required DateTime createdAt,
  }) = _FinancialGoal;

  factory FinancialGoal.fromJson(Map<String, dynamic> json) =>
      _$FinancialGoalFromJson(json);
}
```

### 2. Repository Pattern Implementation

```dart
// lib/repositories/profile_repository.dart
abstract class ProfileRepository {
  // Core CRUD operations
  Future<UserProfile?> getCurrentProfile();
  Future<UserProfile> updateProfile(ProfileUpdateData data);
  
  // Feature management
  Future<void> purchaseFeature(String featureType, {int? count});
  int getFeatureLimit(String featureType);
  bool hasFeature(String featureType);
  int getCurrentFeatureCount(String featureType);
  
  // Goals management
  Future<void> addFinancialGoal(FinancialGoal goal);
  Future<void> updateFinancialGoal(String goalId, FinancialGoal goal);
  Future<void> deleteFinancialGoal(String goalId);
  
  // Preferences
  Future<void> updateNotificationPreferences(NotificationPreferences prefs);
  Future<void> updateBudgetSettings(BudgetSettings settings);
  
  // Profile completion
  Future<void> completeProfile();
  Future<void> completeOnboarding();
}

// lib/repositories/profile_repository_impl.dart
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  
  ProfileRepositoryImpl(this._supabase);
  
  @override
  Future<UserProfile?> getCurrentProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;
      
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      // Handle error appropriately
      throw ProfileException('Failed to fetch profile: $e');
    }
  }
  
  @override
  Future<UserProfile> updateProfile(ProfileUpdateData data) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw ProfileException('User not authenticated');
      
      final response = await _supabase
          .from('profiles')
          .update(data.toJson())
          .eq('id', userId)
          .select()
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      throw ProfileException('Failed to update profile: $e');
    }
  }
  
  @override
  bool hasFeature(String featureType) {
    // Implementation to check if user has purchased a feature
    // This would check the purchasedFeatures map
  }
  
  @override
  int getFeatureLimit(String featureType) {
    final baseLimit = _getBaseLimit(featureType);
    final purchasedCount = getCurrentFeatureCount(featureType);
    return baseLimit + purchasedCount;
  }
  
  int _getBaseLimit(String featureType) {
    switch (featureType) {
      case FeatureLimits.assets:
        return FeatureLimits.baseAssetLimit;
      case FeatureLimits.categories:
        return FeatureLimits.baseCategoryLimit;
      case FeatureLimits.recurringTransactions:
        return FeatureLimits.baseRecurringLimit;
      default:
        return 0;
    }
  }
}
```

### 3. Riverpod State Management

```dart
// lib/providers/auth_providers.dart
@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    final supabase = ref.watch(supabaseProvider);
    
    // Listen to auth state changes
    supabase.auth.onAuthStateChange.listen((data) {
      state = AsyncValue.data(data.user);
    });
    
    return supabase.auth.currentUser;
  }
  
  Future<void> signInWithGoogle() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.yourapp.expense://login-callback/',
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signInWithKakao() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'com.yourapp.expense://login-callback/',
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signOut() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signOut();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// lib/providers/profile_providers.dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<UserProfile?> build() async {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) async {
        if (user == null) return null;
        
        final repository = ref.read(profileRepositoryProvider);
        return await repository.getCurrentProfile();
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
  
  Future<void> updateProfile(ProfileUpdateData data) async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = await repository.updateProfile(data);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> purchaseFeature(String featureType, {int? count}) async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.purchaseFeature(featureType, count: count);
      
      // Refresh profile data
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

@riverpod
bool profileCompleted(ProfileCompletedRef ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.when(
    data: (profile) => profile?.profileCompleted ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
}

@riverpod
bool onboardingCompleted(OnboardingCompletedRef ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.when(
    data: (profile) => profile?.onboardingCompleted ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
}
```

---

## Implementation Guide

### Phase 1: Database Setup (Week 1)

#### Day 1-2: Basic Schema Creation
1. **Create the profiles table**:
   ```sql
   -- Run the profiles table creation SQL from above
   ```

2. **Set up Row Level Security**:
   ```sql
   -- Enable RLS and create policies as shown above
   ```

3. **Create and test the trigger function**:
   ```sql
   -- Create the handle_new_user function and trigger
   ```

#### Day 3-4: OAuth Configuration
1. **Configure OAuth providers in Supabase Dashboard**
2. **Test OAuth flows manually**
3. **Verify profile creation via triggers**

#### Day 5-7: Flutter Integration Setup
1. **Add dependencies** (`supabase_flutter`, `riverpod`, `freezed`, etc.)
2. **Set up deep linking configuration**
3. **Create basic Freezed models**
4. **Implement repository pattern foundation**

### Phase 2: Core Authentication (Week 2)

#### Day 1-3: Authentication Flow
1. **Implement OAuth sign-in methods**
2. **Handle OAuth callbacks and deep links**
3. **Create authentication state management with Riverpod**
4. **Test sign-in/sign-out flows**

#### Day 4-5: Profile Management
1. **Implement profile fetching and updating**
2. **Create profile completion flow**
3. **Handle profile state in UI**

#### Day 6-7: Account Linking
1. **Implement account linking detection**
2. **Create linking confirmation UI**
3. **Handle linking errors and edge cases**

### Phase 3: Feature System (Week 3)

#### Day 1-3: Pay-per-Feature Implementation
1. **Implement feature purchase tracking**
2. **Create feature limit checking logic**
3. **Build feature gates throughout the app**

#### Day 4-5: Goals and Preferences
1. **Implement financial goals management**
2. **Create notification preferences UI**
3. **Handle budget settings**

#### Day 6-7: Polish and Testing
1. **Comprehensive testing of all flows**
2. **Error handling and edge cases**
3. **Performance optimization**

---

## Testing Strategy

### 1. Database Testing

#### Trigger Testing
```sql
-- Test profile creation trigger
DO $$
DECLARE
  test_user_id UUID := gen_random_uuid();
BEGIN
  -- Insert a test user (simulating OAuth signup)
  INSERT INTO auth.users (id, email, raw_user_meta_data)
  VALUES (
    test_user_id,
    'test@example.com',
    '{"full_name": "Test User", "avatar_url": "https://example.com/avatar.jpg"}'
  );
  
  -- Verify profile was created
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = test_user_id) = 1;
  
  -- Verify profile data
  ASSERT (SELECT full_name FROM public.profiles WHERE id = test_user_id) = 'Test User';
  
  -- Cleanup
  DELETE FROM auth.users WHERE id = test_user_id;
  
  RAISE NOTICE 'Trigger test passed!';
END $$;
```

#### RLS Policy Testing
```sql
-- Test RLS policies
DO $$
DECLARE
  user1_id UUID := gen_random_uuid();
  user2_id UUID := gen_random_uuid();
BEGIN
  -- Create test users
  INSERT INTO auth.users (id, email) VALUES (user1_id, 'user1@example.com');
  INSERT INTO auth.users (id, email) VALUES (user2_id, 'user2@example.com');
  
  -- Test that users can only see their own profile
  SET LOCAL "request.jwt.claims" = json_build_object('sub', user1_id);
  
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = user1_id) = 1;
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = user2_id) = 0;
  
  -- Cleanup
  DELETE FROM auth.users WHERE id IN (user1_id, user2_id);
  
  RAISE NOTICE 'RLS test passed!';
END $$;
```

### 2. Flutter Integration Testing

```dart
// test/integration/auth_flow_test.dart
void main() {
  group('Authentication Flow Integration Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabaseClient),
        ],
      );
    });
    
    testWidgets('Complete OAuth sign-in flow', (tester) async {
      // Test OAuth sign-in
      await container.read(authStateProvider.notifier).signInWithGoogle();
      
      // Verify user is authenticated
      final authState = container.read(authStateProvider);
      expect(authState.value, isNotNull);
      
      // Verify profile is created
      final profile = await container.read(userProfileProvider.future);
      expect(profile, isNotNull);
      expect(profile!.profileCompleted, isFalse);
    });
    
    testWidgets('Profile completion flow', (tester) async {
      // Set up authenticated user with incomplete profile
      // ... test profile completion flow
    });
    
    testWidgets('Feature purchase flow', (tester) async {
      // Test purchasing additional features
      // ... test feature purchase and limit updates
    });
  });
}
```

### 3. Repository Testing

```dart
// test/repositories/profile_repository_test.dart
void main() {
  group('ProfileRepository Tests', () {
    late ProfileRepository repository;
    late MockSupabaseClient mockSupabase;
    
    setUp(() {
      mockSupabase = MockSupabaseClient();
      repository = ProfileRepositoryImpl(mockSupabase);
    });
    
    test('getCurrentProfile returns profile for authenticated user', () async {
      // Mock authenticated user
      when(mockSupabase.auth.currentUser)
          .thenReturn(User(id: 'user-id', email: 'test@example.com'));
      
      // Mock database response
      when(mockSupabase.from('profiles').select().eq('id', 'user-id').single())
          .thenAnswer((_) async => mockProfileData);
      
      final profile = await repository.getCurrentProfile();
      
      expect(profile, isNotNull);
      expect(profile!.id, equals('user-id'));
    });
    
    test('hasFeature returns correct feature status', () {
      // Test feature checking logic
      // ... implement feature checking tests
    });
    
    test('getFeatureLimit calculates correct limits', () {
      // Test feature limit calculations
      // ... implement limit calculation tests
    });
  });
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Profile Not Created After OAuth Sign-in

**Symptoms**: User can authenticate but no profile exists in the database.

**Possible Causes**:
- Trigger function has errors
- RLS policies blocking trigger execution
- Insufficient permissions

**Solutions**:
```sql
-- Check trigger exists and is enabled
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- Check function permissions
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO postgres;

--;
      case 'EUR':
        return '€';
      default:
        return currencyCode;
    }
  }
}

// lib/utils/timezone_utils.dart
class TimezoneUtils {
  static DateTime convertToUserTimezone(DateTime utcTime, String timezone) {
    final location = tz.getLocation(timezone);
    return tz.TZDateTime.from(utcTime, location);
  }
  
  static DateTime convertToUTC(DateTime localTime, String timezone) {
    final location = tz.getLocation(timezone);
    final tzDateTime = tz.TZDateTime.from(localTime, location);
    return tzDateTime.toUtc();
  }
}
```

### Performance Optimization

#### 1. Database Query Optimization

**Index Creation for Better Performance**:
```sql
-- Index on profiles table for faster lookups
CREATE INDEX idx_profiles_id ON public.profiles(id);
CREATE INDEX idx_profiles_email ON public.profiles(email);

-- Partial index for incomplete profiles
CREATE INDEX idx_profiles_incomplete 
ON public.profiles(id) 
WHERE profile_completed = false;

-- Index on JSONB fields for feature queries
CREATE INDEX idx_profiles_purchased_features 
ON public.profiles 
USING GIN (purchased_features);
```

**Optimized Profile Queries**:
```sql
-- Instead of SELECT *
SELECT id, email, full_name, avatar_url, primary_currency, 
       profile_completed, onboarding_completed, purchased_features
FROM public.profiles 
WHERE id = $1;

-- For feature checking, create a dedicated function
CREATE OR REPLACE FUNCTION get_user_feature_limits(user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $
DECLARE
  result JSONB;
BEGIN
  SELECT jsonb_build_object(
    'assets', COALESCE((purchased_features->>'assets')::JSONB->>'count', '0')::INT + 2,
    'categories', COALESCE((purchased_features->>'categories')::JSONB->>'count', '0')::INT + 5,
    'recurring_transactions', COALESCE((purchased_features->>'recurring_transactions')::JSONB->>'count', '0')::INT + 2
  ) INTO result
  FROM public.profiles
  WHERE id = user_id;
  
  RETURN result;
END;
$;
```

#### 2. Flutter App Performance

**Profile Data Caching**:
```dart
// lib/services/profile_cache_service.dart
class ProfileCacheService {
  static const String _profileKey = 'cached_profile';
  static const Duration _cacheExpiry = Duration(hours: 1);
  
  static Future<void> cacheProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'profile': profile.toJson(),
      'cached_at': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_profileKey, jsonEncode(cacheData));
  }
  
  static Future<UserProfile?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_profileKey);
    
    if (cachedData == null) return null;
    
    final data = jsonDecode(cachedData);
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(data['cached_at']);
    
    if (DateTime.now().difference(cachedAt) > _cacheExpiry) {
      return null; // Cache expired
    }
    
    return UserProfile.fromJson(data['profile']);
  }
  
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
```

**Optimized Riverpod Providers**:
```dart
// Use caching and debouncing
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<UserProfile?> build() async {
    // Try cache first
    final cached = await ProfileCacheService.getCachedProfile();
    if (cached != null) {
      // Return cached data immediately, refresh in background
      _refreshProfile();
      return cached;
    }
    
    return _fetchProfile();
  }
  
  Future<UserProfile?> _fetchProfile() async {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) async {
        if (user == null) return null;
        
        final repository = ref.read(profileRepositoryProvider);
        final profile = await repository.getCurrentProfile();
        
        if (profile != null) {
          await ProfileCacheService.cacheProfile(profile);
        }
        
        return profile;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
  
  void _refreshProfile() {
    // Refresh in background without affecting current state
    Future.microtask(() async {
      try {
        final freshProfile = await _fetchProfile();
        if (freshProfile != null) {
          state = AsyncValue.data(freshProfile);
        }
      } catch (e) {
        // Log error but don't affect current state
        print('Background refresh failed: $e');
      }
    });
  }
}
```

### Security Best Practices

#### 1. Secure OAuth Implementation

**Token Storage**:
```dart
// lib/services/secure_storage_service.dart
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }
  
  static Future<Map<String, String?>> getTokens() async {
    return {
      'access_token': await _storage.read(key: 'access_token'),
      'refresh_token': await _storage.read(key: 'refresh_token'),
    };
  }
  
  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
```

#### 2. Input Validation and Sanitization

**Profile Data Validation**:
```dart
// lib/validators/profile_validators.dart
class ProfileValidators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  static String? validateCurrency(String? currency) {
    const supportedCurrencies = ['KRW', 'USD', 'EUR', 'JPY', 'GBP'];
    
    if (currency == null || currency.isEmpty) {
      return 'Currency is required';
    }
    
    if (!supportedCurrencies.contains(currency)) {
      return 'Unsupported currency';
    }
    
    return null;
  }
  
  static String? validateGoalAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 'Amount is required';
    }
    
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'Please enter a valid positive amount';
    }
    
    if (parsedAmount > 999999999) {
      return 'Amount too large';
    }
    
    return null;
  }
}
```

#### 3. Error Handling and Logging

**Centralized Error Handling**:
```dart
// lib/services/error_service.dart
class ErrorService {
  static void logError(dynamic error, StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    // Log to console in debug mode
    if (kDebugMode) {
      print('Error in $context: $error');
      print('Stack trace: $stackTrace');
      if (additionalData != null) {
        print('Additional data: $additionalData');
      }
    }
    
    // In production, send to error tracking service
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
  
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _getAuthErrorMessage(error);
    } else if (error is PostgrestException) {
      return _getDatabaseErrorMessage(error);
    } else if (error is ProfileException) {
      return error.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
  
  static String _getAuthErrorMessage(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'Invalid email or password. Please check your credentials.';
      case 'Email not confirmed':
        return 'Please check your email and click the confirmation link.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
  
  static String _getDatabaseErrorMessage(PostgrestException error) {
    if (error.message.contains('duplicate key')) {
      return 'This data already exists.';
    } else if (error.message.contains('foreign key')) {
      return 'Referenced data not found.';
    } else {
      return 'Database error occurred. Please try again.';
    }
  }
}

// lib/exceptions/profile_exception.dart
class ProfileException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const ProfileException(
    this.message, {
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => 'ProfileException: $message';
}
```

### Monitoring and Analytics

#### 1. Database Monitoring

**Profile Creation Monitoring**:
```sql
-- Create a view for monitoring profile creation
CREATE VIEW profile_creation_stats AS
SELECT 
  DATE(created_at) as creation_date,
  COUNT(*) as profiles_created,
  COUNT(CASE WHEN profile_completed THEN 1 END) as completed_profiles,
  ROUND(
    COUNT(CASE WHEN profile_completed THEN 1 END) * 100.0 / COUNT(*), 
    2
  ) as completion_rate
FROM public.profiles 
GROUP BY DATE(created_at)
ORDER BY creation_date DESC;

-- Monitor trigger performance
CREATE VIEW trigger_performance AS
SELECT 
  schemaname,
  tablename,
  triggername,
  -- Add performance monitoring here
FROM pg_stat_user_triggers;
```

#### 2. Application Monitoring

**Performance Tracking**:
```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  static void trackProfileCreation({
    required String method, // 'google', 'kakao'
    required Duration timeToComplete,
  }) {
    // Track user onboarding performance
    _trackEvent('profile_created', {
      'auth_method': method,
      'completion_time_ms': timeToComplete.inMilliseconds,
    });
  }
  
  static void trackFeaturePurchase({
    required String featureType,
    required int count,
    required String currency,
    required double amount,
  }) {
    _trackEvent('feature_purchased', {
      'feature_type': featureType,
      'count': count,
      'currency': currency,
      'amount': amount,
    });
  }
  
  static void trackError({
    required String errorType,
    required String context,
    String? additionalInfo,
  }) {
    _trackEvent('error_occurred', {
      'error_type': errorType,
      'context': context,
      'additional_info': additionalInfo,
    });
  }
  
  static void _trackEvent(String eventName, Map<String, dynamic> parameters) {
    // Implementation depends on your analytics provider
    // FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }
}
```

---

## Conclusion

This documentation provides a comprehensive guide for implementing a user and profile management system for your expense tracking app. The architecture supports:

- **Scalable Authentication**: OAuth integration with account linking
- **Flexible Profile System**: Progressive setup with smart defaults
- **Pay-per-Feature Model**: Extensible feature purchase system
- **Multi-currency Support**: Localization-ready structure
- **Security Best Practices**: RLS policies and proper error handling
- **Performance Optimization**: Caching and efficient queries

### Next Steps

1. **Implement the database schema and triggers**
2. **Set up OAuth providers in Supabase**
3. **Build the Flutter authentication flow**
4. **Create the profile management system**
5. **Implement the pay-per-feature logic**
6. **Add comprehensive testing**
7. **Set up monitoring and analytics**

Remember to test thoroughly at each step and follow security best practices throughout the implementation process.functions)
6. [Row Level Security (RLS)](#row-level-security-rls)
7. [Flutter Integration](#flutter-integration)
8. [Implementation Guide](#implementation-guide)
9. [Testing Strategy](#testing-strategy)
10. [Troubleshooting](#troubleshooting)

---

## Overview

This documentation outlines the user and profile model architecture for an expense tracking app built with Flutter and Supabase. The system implements a pay-per-feature SaaS model where users can purchase additional capabilities permanently (not subscription-based).

### Key Features
- **Social Authentication**: Google and Kakao OAuth login
- **Account Linking**: Users can link multiple social accounts
- **Progressive Profile Setup**: Users can start using the app immediately
- **Pay-per-Feature Model**: Purchase additional features permanently
- **Multi-currency Support**: Primary currency with conversion handling
- **Notification Preferences**: Customizable alerts and reminders
- **Financial Goals**: Simple saving and spending goals

---

## Database Architecture

### Core Tables Structure

#### 1. auth.users (Supabase Managed)
This table is automatically managed by Supabase Auth and contains:
- `id` (UUID, primary key)
- `email` (text)
- `phone` (text, nullable)
- `email_confirmed_at` (timestamp)
- `confirmation_token` (text)
- `recovery_token` (text)
- `email_change_token_new` (text)
- `email_change` (text)
- `last_sign_in_at` (timestamp)
- `raw_app_meta_data` (jsonb)
- `raw_user_meta_data` (jsonb)
- `is_super_admin` (boolean)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 2. public.profiles (Custom Table)
This table extends user data and is automatically created via triggers:

```sql
CREATE TABLE public.profiles (
  -- Identity
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  
  -- Localization & Preferences
  primary_currency TEXT NOT NULL DEFAULT 'KRW',
  secondary_currencies TEXT[] DEFAULT '{}',
  timezone TEXT NOT NULL DEFAULT 'Asia/Seoul',
  locale TEXT NOT NULL DEFAULT 'ko',
  country_code TEXT NOT NULL DEFAULT 'KR',
  
  -- Feature Purchases (Pay-per-feature model)
  purchased_features JSONB NOT NULL DEFAULT '{}',
  
  -- Notification Preferences
  notification_preferences JSONB NOT NULL DEFAULT '{
    "weekly_summary": {"enabled": true, "day_of_week": "sunday", "time": "18:00"},
    "daily_reminder": {"enabled": true, "time": "21:00"},
    "budget_alerts": {"enabled": true, "weekly_threshold": 80, "monthly_threshold": 80}
  }',
  
  -- Budget Settings
  default_budget_settings JSONB NOT NULL DEFAULT '{
    "weekly_budget": null,
    "monthly_budget": null,
    "budget_start_day": "monday"
  }',
  
  -- Financial Goals (Simple structure)
  financial_goals JSONB NOT NULL DEFAULT '[]',
  
  -- App Preferences
  app_preferences JSONB NOT NULL DEFAULT '{
    "currency_conversion_warnings": true,
    "quick_add_enabled": true,
    "default_transaction_time": "current"
  }',
  
  -- Profile State
  profile_completed BOOLEAN NOT NULL DEFAULT false,
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## Social Authentication Setup

### 1. Configure OAuth Providers in Supabase Dashboard

#### Google OAuth Configuration
1. Navigate to **Authentication → Providers** in your Supabase dashboard
2. Enable Google provider
3. Add your Google OAuth credentials:
   - Client ID
   - Client Secret
4. Set redirect URLs:
   - Development: `com.yourapp.expense://login-callback/`
   - Production: `com.yourapp.expense://login-callback/`

#### Kakao OAuth Configuration
1. Enable Kakao provider in the dashboard
2. Configure Kakao OAuth app settings
3. Add redirect URLs following Kakao's requirements
4. Set proper scopes for email and profile access

### 2. Flutter Deep Link Configuration

#### Android Configuration (`android/app/src/main/AndroidManifest.xml`)
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">
    
    <!-- Standard Flutter configuration -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- OAuth callback configuration -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="com.yourapp.expense" />
    </intent-filter>
</activity>
```

#### iOS Configuration (`ios/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourapp.expense</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.yourapp.expense</string>
        </array>
    </dict>
</array>
```

---

## Profile Model Structure

### Feature Purchase System

The `purchased_features` JSONB field stores feature ownership:

```json
{
  "assets": {
    "count": 10,
    "purchased_at": "2025-01-15T10:30:00Z"
  },
  "categories": {
    "count": 15,
    "purchased_at": "2025-01-20T14:20:00Z"
  },
  "user_sharing": {
    "enabled": true,
    "purchased_at": "2025-02-01T09:15:00Z"
  },
  "dashboard_charts": {
    "enabled": true,
    "purchased_at": "2025-02-10T16:45:00Z"
  },
  "recurring_transactions": {
    "count": 8,
    "purchased_at": "2025-02-15T11:30:00Z"
  }
}
```

### Base Feature Limits (App Constants)
```dart
// These are constants in your Flutter app, not stored in the database
class FeatureLimits {
  static const int baseAssetLimit = 2;
  static const int baseCategoryLimit = 5;
  static const int baseRecurringLimit = 2;
  
  // Feature types
  static const String assets = 'assets';
  static const String categories = 'categories';
  static const String userSharing = 'user_sharing';
  static const String dashboardCharts = 'dashboard_charts';
  static const String recurringTransactions = 'recurring_transactions';
}
```

### Financial Goals Structure

Simple goal types stored in the `financial_goals` JSONB array:

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "type": "save_amount",
    "amount": 1000000,
    "currency": "KRW",
    "target_date": "2025-12-31",
    "created_at": "2025-01-15T10:30:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "type": "spend_less_than",
    "amount": 500000,
    "currency": "KRW",
    "period": "monthly",
    "created_at": "2025-01-20T14:20:00Z"
  }
]
```

**Goal Types:**
- `save_amount`: Save X amount by target_date
- `spend_less_than`: Spend less than X in period (weekly/monthly)

---

## Database Triggers & Functions

### 1. Profile Creation Trigger Function

This function automatically creates a profile when a user signs up via OAuth:

```sql
-- Function to handle new user profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  user_email TEXT;
  user_name TEXT;
  user_avatar TEXT;
BEGIN
  -- Extract email from auth.users
  user_email := NEW.email;
  
  -- Safely extract name from raw_user_meta_data
  user_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'name',
    split_part(user_email, '@', 1)
  );
  
  -- Safely extract avatar URL
  user_avatar := COALESCE(
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.raw_user_meta_data->>'picture'
  );
  
  -- Insert profile with smart defaults
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    avatar_url,
    primary_currency,
    timezone,
    locale,
    country_code,
    purchased_features,
    notification_preferences,
    default_budget_settings,
    financial_goals,
    app_preferences,
    profile_completed,
    onboarding_completed,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    user_email,
    user_name,
    user_avatar,
    'KRW', -- Default currency
    'Asia/Seoul', -- Default timezone
    'ko', -- Default locale
    'KR', -- Default country
    '{}', -- Empty purchased features
    '{
      "weekly_summary": {"enabled": true, "day_of_week": "sunday", "time": "18:00"},
      "daily_reminder": {"enabled": true, "time": "21:00"},
      "budget_alerts": {"enabled": true, "weekly_threshold": 80, "monthly_threshold": 80}
    }',
    '{
      "weekly_budget": null,
      "monthly_budget": null,
      "budget_start_day": "monday"
    }',
    '[]', -- Empty financial goals
    '{
      "currency_conversion_warnings": true,
      "quick_add_enabled": true,
      "default_transaction_time": "current"
    }',
    false, -- Profile not completed initially
    false, -- Onboarding not completed
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING; -- Prevent duplicate profiles during account linking
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't prevent user creation
    RAISE LOG 'Error creating profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;
```

### 2. Create the Trigger

```sql
-- Create trigger to automatically create profiles
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW 
  EXECUTE FUNCTION public.handle_new_user();
```

### 3. Updated At Trigger Function

```sql
-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Create trigger for updated_at
CREATE TRIGGER handle_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();
```

---

## Row Level Security (RLS)

### 1. Enable RLS on Profiles Table

```sql
-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
```

### 2. Create RLS Policies

```sql
-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile" 
ON public.profiles 
FOR SELECT 
TO authenticated 
USING ((SELECT auth.uid()) = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile" 
ON public.profiles 
FOR UPDATE 
TO authenticated 
USING ((SELECT auth.uid()) = id)
WITH CHECK ((SELECT auth.uid()) = id);

-- Policy: Prevent direct INSERT (only via trigger)
CREATE POLICY "Prevent direct profile creation" 
ON public.profiles 
FOR INSERT 
TO authenticated 
WITH CHECK (false);

-- Policy: Users can delete their own profile (optional)
CREATE POLICY "Users can delete own profile" 
ON public.profiles 
FOR DELETE 
TO authenticated 
USING ((SELECT auth.uid()) = id);

-- Policy: Service role bypasses RLS for admin operations
-- This allows your backend services to manage profiles if needed
```

### 3. Grant Necessary Permissions

```sql
-- Grant permissions to authenticated users
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- Grant permissions for the trigger function
GRANT INSERT ON public.profiles TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres;
```

---

## Flutter Integration

### 1. Freezed Data Models

```dart
// lib/models/user_profile.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
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
}

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required WeeklySummarySettings weeklySummary,
    required DailyReminderSettings dailyReminder,
    required BudgetAlertSettings budgetAlerts,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

@freezed
class FinancialGoal with _$FinancialGoal {
  const factory FinancialGoal({
    required String id,
    required String type, // 'save_amount' or 'spend_less_than'
    required double amount,
    required String currency,
    String? period, // 'weekly' or 'monthly' for spend_less_than
    DateTime? targetDate, // for save_amount goals
    required DateTime createdAt,
  }) = _FinancialGoal;

  factory FinancialGoal.fromJson(Map<String, dynamic> json) =>
      _$FinancialGoalFromJson(json);
}
```

### 2. Repository Pattern Implementation

```dart
// lib/repositories/profile_repository.dart
abstract class ProfileRepository {
  // Core CRUD operations
  Future<UserProfile?> getCurrentProfile();
  Future<UserProfile> updateProfile(ProfileUpdateData data);
  
  // Feature management
  Future<void> purchaseFeature(String featureType, {int? count});
  int getFeatureLimit(String featureType);
  bool hasFeature(String featureType);
  int getCurrentFeatureCount(String featureType);
  
  // Goals management
  Future<void> addFinancialGoal(FinancialGoal goal);
  Future<void> updateFinancialGoal(String goalId, FinancialGoal goal);
  Future<void> deleteFinancialGoal(String goalId);
  
  // Preferences
  Future<void> updateNotificationPreferences(NotificationPreferences prefs);
  Future<void> updateBudgetSettings(BudgetSettings settings);
  
  // Profile completion
  Future<void> completeProfile();
  Future<void> completeOnboarding();
}

// lib/repositories/profile_repository_impl.dart
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  
  ProfileRepositoryImpl(this._supabase);
  
  @override
  Future<UserProfile?> getCurrentProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;
      
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      // Handle error appropriately
      throw ProfileException('Failed to fetch profile: $e');
    }
  }
  
  @override
  Future<UserProfile> updateProfile(ProfileUpdateData data) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw ProfileException('User not authenticated');
      
      final response = await _supabase
          .from('profiles')
          .update(data.toJson())
          .eq('id', userId)
          .select()
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      throw ProfileException('Failed to update profile: $e');
    }
  }
  
  @override
  bool hasFeature(String featureType) {
    // Implementation to check if user has purchased a feature
    // This would check the purchasedFeatures map
  }
  
  @override
  int getFeatureLimit(String featureType) {
    final baseLimit = _getBaseLimit(featureType);
    final purchasedCount = getCurrentFeatureCount(featureType);
    return baseLimit + purchasedCount;
  }
  
  int _getBaseLimit(String featureType) {
    switch (featureType) {
      case FeatureLimits.assets:
        return FeatureLimits.baseAssetLimit;
      case FeatureLimits.categories:
        return FeatureLimits.baseCategoryLimit;
      case FeatureLimits.recurringTransactions:
        return FeatureLimits.baseRecurringLimit;
      default:
        return 0;
    }
  }
}
```

### 3. Riverpod State Management

```dart
// lib/providers/auth_providers.dart
@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    final supabase = ref.watch(supabaseProvider);
    
    // Listen to auth state changes
    supabase.auth.onAuthStateChange.listen((data) {
      state = AsyncValue.data(data.user);
    });
    
    return supabase.auth.currentUser;
  }
  
  Future<void> signInWithGoogle() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.yourapp.expense://login-callback/',
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signInWithKakao() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'com.yourapp.expense://login-callback/',
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signOut() async {
    try {
      final supabase = ref.read(supabaseProvider);
      await supabase.auth.signOut();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// lib/providers/profile_providers.dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<UserProfile?> build() async {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) async {
        if (user == null) return null;
        
        final repository = ref.read(profileRepositoryProvider);
        return await repository.getCurrentProfile();
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
  
  Future<void> updateProfile(ProfileUpdateData data) async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = await repository.updateProfile(data);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> purchaseFeature(String featureType, {int? count}) async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.purchaseFeature(featureType, count: count);
      
      // Refresh profile data
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

@riverpod
bool profileCompleted(ProfileCompletedRef ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.when(
    data: (profile) => profile?.profileCompleted ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
}

@riverpod
bool onboardingCompleted(OnboardingCompletedRef ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.when(
    data: (profile) => profile?.onboardingCompleted ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
}
```

---

## Implementation Guide

### Phase 1: Database Setup (Week 1)

#### Day 1-2: Basic Schema Creation
1. **Create the profiles table**:
   ```sql
   -- Run the profiles table creation SQL from above
   ```

2. **Set up Row Level Security**:
   ```sql
   -- Enable RLS and create policies as shown above
   ```

3. **Create and test the trigger function**:
   ```sql
   -- Create the handle_new_user function and trigger
   ```

#### Day 3-4: OAuth Configuration
1. **Configure OAuth providers in Supabase Dashboard**
2. **Test OAuth flows manually**
3. **Verify profile creation via triggers**

#### Day 5-7: Flutter Integration Setup
1. **Add dependencies** (`supabase_flutter`, `riverpod`, `freezed`, etc.)
2. **Set up deep linking configuration**
3. **Create basic Freezed models**
4. **Implement repository pattern foundation**

### Phase 2: Core Authentication (Week 2)

#### Day 1-3: Authentication Flow
1. **Implement OAuth sign-in methods**
2. **Handle OAuth callbacks and deep links**
3. **Create authentication state management with Riverpod**
4. **Test sign-in/sign-out flows**

#### Day 4-5: Profile Management
1. **Implement profile fetching and updating**
2. **Create profile completion flow**
3. **Handle profile state in UI**

#### Day 6-7: Account Linking
1. **Implement account linking detection**
2. **Create linking confirmation UI**
3. **Handle linking errors and edge cases**

### Phase 3: Feature System (Week 3)

#### Day 1-3: Pay-per-Feature Implementation
1. **Implement feature purchase tracking**
2. **Create feature limit checking logic**
3. **Build feature gates throughout the app**

#### Day 4-5: Goals and Preferences
1. **Implement financial goals management**
2. **Create notification preferences UI**
3. **Handle budget settings**

#### Day 6-7: Polish and Testing
1. **Comprehensive testing of all flows**
2. **Error handling and edge cases**
3. **Performance optimization**

---

## Testing Strategy

### 1. Database Testing

#### Trigger Testing
```sql
-- Test profile creation trigger
DO $$
DECLARE
  test_user_id UUID := gen_random_uuid();
BEGIN
  -- Insert a test user (simulating OAuth signup)
  INSERT INTO auth.users (id, email, raw_user_meta_data)
  VALUES (
    test_user_id,
    'test@example.com',
    '{"full_name": "Test User", "avatar_url": "https://example.com/avatar.jpg"}'
  );
  
  -- Verify profile was created
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = test_user_id) = 1;
  
  -- Verify profile data
  ASSERT (SELECT full_name FROM public.profiles WHERE id = test_user_id) = 'Test User';
  
  -- Cleanup
  DELETE FROM auth.users WHERE id = test_user_id;
  
  RAISE NOTICE 'Trigger test passed!';
END $$;
```

#### RLS Policy Testing
```sql
-- Test RLS policies
DO $$
DECLARE
  user1_id UUID := gen_random_uuid();
  user2_id UUID := gen_random_uuid();
BEGIN
  -- Create test users
  INSERT INTO auth.users (id, email) VALUES (user1_id, 'user1@example.com');
  INSERT INTO auth.users (id, email) VALUES (user2_id, 'user2@example.com');
  
  -- Test that users can only see their own profile
  SET LOCAL "request.jwt.claims" = json_build_object('sub', user1_id);
  
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = user1_id) = 1;
  ASSERT (SELECT COUNT(*) FROM public.profiles WHERE id = user2_id) = 0;
  
  -- Cleanup
  DELETE FROM auth.users WHERE id IN (user1_id, user2_id);
  
  RAISE NOTICE 'RLS test passed!';
END $$;
```

### 2. Flutter Integration Testing

```dart
// test/integration/auth_flow_test.dart
void main() {
  group('Authentication Flow Integration Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabaseClient),
        ],
      );
    });
    
    testWidgets('Complete OAuth sign-in flow', (tester) async {
      // Test OAuth sign-in
      await container.read(authStateProvider.notifier).signInWithGoogle();
      
      // Verify user is authenticated
      final authState = container.read(authStateProvider);
      expect(authState.value, isNotNull);
      
      // Verify profile is created
      final profile = await container.read(userProfileProvider.future);
      expect(profile, isNotNull);
      expect(profile!.profileCompleted, isFalse);
    });
    
    testWidgets('Profile completion flow', (tester) async {
      // Set up authenticated user with incomplete profile
      // ... test profile completion flow
    });
    
    testWidgets('Feature purchase flow', (tester) async {
      // Test purchasing additional features
      // ... test feature purchase and limit updates
    });
  });
}
```

### 3. Repository Testing

```dart
// test/repositories/profile_repository_test.dart
void main() {
  group('ProfileRepository Tests', () {
    late ProfileRepository repository;
    late MockSupabaseClient mockSupabase;
    
    setUp(() {
      mockSupabase = MockSupabaseClient();
      repository = ProfileRepositoryImpl(mockSupabase);
    });
    
    test('getCurrentProfile returns profile for authenticated user', () async {
      // Mock authenticated user
      when(mockSupabase.auth.currentUser)
          .thenReturn(User(id: 'user-id', email: 'test@example.com'));
      
      // Mock database response
      when(mockSupabase.from('profiles').select().eq('id', 'user-id').single())
          .thenAnswer((_) async => mockProfileData);
      
      final profile = await repository.getCurrentProfile();
      
      expect(profile, isNotNull);
      expect(profile!.id, equals('user-id'));
    });
    
    test('hasFeature returns correct feature status', () {
      // Test feature checking logic
      // ... implement feature checking tests
    });
    
    test('getFeatureLimit calculates correct limits', () {
      // Test feature limit calculations
      // ... implement limit calculation tests
    });
  });
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Profile Not Created After OAuth Sign-in

**Symptoms**: User can authenticate but no profile exists in the database.

**Possible Causes**:
- Trigger function has errors
- RLS policies blocking trigger execution
- Insufficient permissions

**Solutions**:
```sql
-- Check trigger exists and is enabled
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- Check function permissions
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO postgres;

--