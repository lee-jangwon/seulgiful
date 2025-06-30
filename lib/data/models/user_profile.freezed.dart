// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get email; String? get fullName; String? get avatarUrl; String get primaryCurrency; List<String> get secondaryCurrencies; String get timezone; String get locale; String get countryCode; Map<String, dynamic> get purchasedFeatures; NotificationPreferences get notificationPreferences; BudgetSettings get defaultBudgetSettings; List<FinancialGoal> get financialGoals; AppPreferences get appPreferences; bool get profileCompleted; bool get onboardingCompleted; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&const DeepCollectionEquality().equals(other.secondaryCurrencies, secondaryCurrencies)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&const DeepCollectionEquality().equals(other.purchasedFeatures, purchasedFeatures)&&(identical(other.notificationPreferences, notificationPreferences) || other.notificationPreferences == notificationPreferences)&&(identical(other.defaultBudgetSettings, defaultBudgetSettings) || other.defaultBudgetSettings == defaultBudgetSettings)&&const DeepCollectionEquality().equals(other.financialGoals, financialGoals)&&(identical(other.appPreferences, appPreferences) || other.appPreferences == appPreferences)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,avatarUrl,primaryCurrency,const DeepCollectionEquality().hash(secondaryCurrencies),timezone,locale,countryCode,const DeepCollectionEquality().hash(purchasedFeatures),notificationPreferences,defaultBudgetSettings,const DeepCollectionEquality().hash(financialGoals),appPreferences,profileCompleted,onboardingCompleted,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl, primaryCurrency: $primaryCurrency, secondaryCurrencies: $secondaryCurrencies, timezone: $timezone, locale: $locale, countryCode: $countryCode, purchasedFeatures: $purchasedFeatures, notificationPreferences: $notificationPreferences, defaultBudgetSettings: $defaultBudgetSettings, financialGoals: $financialGoals, appPreferences: $appPreferences, profileCompleted: $profileCompleted, onboardingCompleted: $onboardingCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? fullName, String? avatarUrl, String primaryCurrency, List<String> secondaryCurrencies, String timezone, String locale, String countryCode, Map<String, dynamic> purchasedFeatures, NotificationPreferences notificationPreferences, BudgetSettings defaultBudgetSettings, List<FinancialGoal> financialGoals, AppPreferences appPreferences, bool profileCompleted, bool onboardingCompleted, DateTime createdAt, DateTime updatedAt
});


$NotificationPreferencesCopyWith<$Res> get notificationPreferences;$BudgetSettingsCopyWith<$Res> get defaultBudgetSettings;$AppPreferencesCopyWith<$Res> get appPreferences;

}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? primaryCurrency = null,Object? secondaryCurrencies = null,Object? timezone = null,Object? locale = null,Object? countryCode = null,Object? purchasedFeatures = null,Object? notificationPreferences = null,Object? defaultBudgetSettings = null,Object? financialGoals = null,Object? appPreferences = null,Object? profileCompleted = null,Object? onboardingCompleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,secondaryCurrencies: null == secondaryCurrencies ? _self.secondaryCurrencies : secondaryCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,purchasedFeatures: null == purchasedFeatures ? _self.purchasedFeatures : purchasedFeatures // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,notificationPreferences: null == notificationPreferences ? _self.notificationPreferences : notificationPreferences // ignore: cast_nullable_to_non_nullable
as NotificationPreferences,defaultBudgetSettings: null == defaultBudgetSettings ? _self.defaultBudgetSettings : defaultBudgetSettings // ignore: cast_nullable_to_non_nullable
as BudgetSettings,financialGoals: null == financialGoals ? _self.financialGoals : financialGoals // ignore: cast_nullable_to_non_nullable
as List<FinancialGoal>,appPreferences: null == appPreferences ? _self.appPreferences : appPreferences // ignore: cast_nullable_to_non_nullable
as AppPreferences,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<$Res> get notificationPreferences {
  
  return $NotificationPreferencesCopyWith<$Res>(_self.notificationPreferences, (value) {
    return _then(_self.copyWith(notificationPreferences: value));
  });
}/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetSettingsCopyWith<$Res> get defaultBudgetSettings {
  
  return $BudgetSettingsCopyWith<$Res>(_self.defaultBudgetSettings, (value) {
    return _then(_self.copyWith(defaultBudgetSettings: value));
  });
}/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppPreferencesCopyWith<$Res> get appPreferences {
  
  return $AppPreferencesCopyWith<$Res>(_self.appPreferences, (value) {
    return _then(_self.copyWith(appPreferences: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.email, this.fullName, this.avatarUrl, this.primaryCurrency = 'KRW', final  List<String> secondaryCurrencies = const [], this.timezone = 'Asia/Seoul', this.locale = 'ko', this.countryCode = 'KR', final  Map<String, dynamic> purchasedFeatures = const {}, required this.notificationPreferences, required this.defaultBudgetSettings, final  List<FinancialGoal> financialGoals = const [], required this.appPreferences, this.profileCompleted = false, this.onboardingCompleted = false, required this.createdAt, required this.updatedAt}): _secondaryCurrencies = secondaryCurrencies,_purchasedFeatures = purchasedFeatures,_financialGoals = financialGoals;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? fullName;
@override final  String? avatarUrl;
@override@JsonKey() final  String primaryCurrency;
 final  List<String> _secondaryCurrencies;
@override@JsonKey() List<String> get secondaryCurrencies {
  if (_secondaryCurrencies is EqualUnmodifiableListView) return _secondaryCurrencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryCurrencies);
}

@override@JsonKey() final  String timezone;
@override@JsonKey() final  String locale;
@override@JsonKey() final  String countryCode;
 final  Map<String, dynamic> _purchasedFeatures;
@override@JsonKey() Map<String, dynamic> get purchasedFeatures {
  if (_purchasedFeatures is EqualUnmodifiableMapView) return _purchasedFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_purchasedFeatures);
}

@override final  NotificationPreferences notificationPreferences;
@override final  BudgetSettings defaultBudgetSettings;
 final  List<FinancialGoal> _financialGoals;
@override@JsonKey() List<FinancialGoal> get financialGoals {
  if (_financialGoals is EqualUnmodifiableListView) return _financialGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_financialGoals);
}

@override final  AppPreferences appPreferences;
@override@JsonKey() final  bool profileCompleted;
@override@JsonKey() final  bool onboardingCompleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&const DeepCollectionEquality().equals(other._secondaryCurrencies, _secondaryCurrencies)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&const DeepCollectionEquality().equals(other._purchasedFeatures, _purchasedFeatures)&&(identical(other.notificationPreferences, notificationPreferences) || other.notificationPreferences == notificationPreferences)&&(identical(other.defaultBudgetSettings, defaultBudgetSettings) || other.defaultBudgetSettings == defaultBudgetSettings)&&const DeepCollectionEquality().equals(other._financialGoals, _financialGoals)&&(identical(other.appPreferences, appPreferences) || other.appPreferences == appPreferences)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,avatarUrl,primaryCurrency,const DeepCollectionEquality().hash(_secondaryCurrencies),timezone,locale,countryCode,const DeepCollectionEquality().hash(_purchasedFeatures),notificationPreferences,defaultBudgetSettings,const DeepCollectionEquality().hash(_financialGoals),appPreferences,profileCompleted,onboardingCompleted,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl, primaryCurrency: $primaryCurrency, secondaryCurrencies: $secondaryCurrencies, timezone: $timezone, locale: $locale, countryCode: $countryCode, purchasedFeatures: $purchasedFeatures, notificationPreferences: $notificationPreferences, defaultBudgetSettings: $defaultBudgetSettings, financialGoals: $financialGoals, appPreferences: $appPreferences, profileCompleted: $profileCompleted, onboardingCompleted: $onboardingCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? fullName, String? avatarUrl, String primaryCurrency, List<String> secondaryCurrencies, String timezone, String locale, String countryCode, Map<String, dynamic> purchasedFeatures, NotificationPreferences notificationPreferences, BudgetSettings defaultBudgetSettings, List<FinancialGoal> financialGoals, AppPreferences appPreferences, bool profileCompleted, bool onboardingCompleted, DateTime createdAt, DateTime updatedAt
});


@override $NotificationPreferencesCopyWith<$Res> get notificationPreferences;@override $BudgetSettingsCopyWith<$Res> get defaultBudgetSettings;@override $AppPreferencesCopyWith<$Res> get appPreferences;

}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? primaryCurrency = null,Object? secondaryCurrencies = null,Object? timezone = null,Object? locale = null,Object? countryCode = null,Object? purchasedFeatures = null,Object? notificationPreferences = null,Object? defaultBudgetSettings = null,Object? financialGoals = null,Object? appPreferences = null,Object? profileCompleted = null,Object? onboardingCompleted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,secondaryCurrencies: null == secondaryCurrencies ? _self._secondaryCurrencies : secondaryCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,purchasedFeatures: null == purchasedFeatures ? _self._purchasedFeatures : purchasedFeatures // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,notificationPreferences: null == notificationPreferences ? _self.notificationPreferences : notificationPreferences // ignore: cast_nullable_to_non_nullable
as NotificationPreferences,defaultBudgetSettings: null == defaultBudgetSettings ? _self.defaultBudgetSettings : defaultBudgetSettings // ignore: cast_nullable_to_non_nullable
as BudgetSettings,financialGoals: null == financialGoals ? _self._financialGoals : financialGoals // ignore: cast_nullable_to_non_nullable
as List<FinancialGoal>,appPreferences: null == appPreferences ? _self.appPreferences : appPreferences // ignore: cast_nullable_to_non_nullable
as AppPreferences,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<$Res> get notificationPreferences {
  
  return $NotificationPreferencesCopyWith<$Res>(_self.notificationPreferences, (value) {
    return _then(_self.copyWith(notificationPreferences: value));
  });
}/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetSettingsCopyWith<$Res> get defaultBudgetSettings {
  
  return $BudgetSettingsCopyWith<$Res>(_self.defaultBudgetSettings, (value) {
    return _then(_self.copyWith(defaultBudgetSettings: value));
  });
}/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppPreferencesCopyWith<$Res> get appPreferences {
  
  return $AppPreferencesCopyWith<$Res>(_self.appPreferences, (value) {
    return _then(_self.copyWith(appPreferences: value));
  });
}
}

// dart format on
