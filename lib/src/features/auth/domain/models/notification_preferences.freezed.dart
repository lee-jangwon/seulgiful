// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferences {

 WeeklySummarySettings get weeklySummary; DailyReminderSettings get dailyReminder; BudgetAlertSettings get budgetAlerts;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.weeklySummary, weeklySummary) || other.weeklySummary == weeklySummary)&&(identical(other.dailyReminder, dailyReminder) || other.dailyReminder == dailyReminder)&&(identical(other.budgetAlerts, budgetAlerts) || other.budgetAlerts == budgetAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklySummary,dailyReminder,budgetAlerts);

@override
String toString() {
  return 'NotificationPreferences(weeklySummary: $weeklySummary, dailyReminder: $dailyReminder, budgetAlerts: $budgetAlerts)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 WeeklySummarySettings weeklySummary, DailyReminderSettings dailyReminder, BudgetAlertSettings budgetAlerts
});


$WeeklySummarySettingsCopyWith<$Res> get weeklySummary;$DailyReminderSettingsCopyWith<$Res> get dailyReminder;$BudgetAlertSettingsCopyWith<$Res> get budgetAlerts;

}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weeklySummary = null,Object? dailyReminder = null,Object? budgetAlerts = null,}) {
  return _then(_self.copyWith(
weeklySummary: null == weeklySummary ? _self.weeklySummary : weeklySummary // ignore: cast_nullable_to_non_nullable
as WeeklySummarySettings,dailyReminder: null == dailyReminder ? _self.dailyReminder : dailyReminder // ignore: cast_nullable_to_non_nullable
as DailyReminderSettings,budgetAlerts: null == budgetAlerts ? _self.budgetAlerts : budgetAlerts // ignore: cast_nullable_to_non_nullable
as BudgetAlertSettings,
  ));
}
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklySummarySettingsCopyWith<$Res> get weeklySummary {
  
  return $WeeklySummarySettingsCopyWith<$Res>(_self.weeklySummary, (value) {
    return _then(_self.copyWith(weeklySummary: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyReminderSettingsCopyWith<$Res> get dailyReminder {
  
  return $DailyReminderSettingsCopyWith<$Res>(_self.dailyReminder, (value) {
    return _then(_self.copyWith(dailyReminder: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetAlertSettingsCopyWith<$Res> get budgetAlerts {
  
  return $BudgetAlertSettingsCopyWith<$Res>(_self.budgetAlerts, (value) {
    return _then(_self.copyWith(budgetAlerts: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _NotificationPreferences implements NotificationPreferences {
  const _NotificationPreferences({required this.weeklySummary, required this.dailyReminder, required this.budgetAlerts});
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override final  WeeklySummarySettings weeklySummary;
@override final  DailyReminderSettings dailyReminder;
@override final  BudgetAlertSettings budgetAlerts;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.weeklySummary, weeklySummary) || other.weeklySummary == weeklySummary)&&(identical(other.dailyReminder, dailyReminder) || other.dailyReminder == dailyReminder)&&(identical(other.budgetAlerts, budgetAlerts) || other.budgetAlerts == budgetAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklySummary,dailyReminder,budgetAlerts);

@override
String toString() {
  return 'NotificationPreferences(weeklySummary: $weeklySummary, dailyReminder: $dailyReminder, budgetAlerts: $budgetAlerts)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 WeeklySummarySettings weeklySummary, DailyReminderSettings dailyReminder, BudgetAlertSettings budgetAlerts
});


@override $WeeklySummarySettingsCopyWith<$Res> get weeklySummary;@override $DailyReminderSettingsCopyWith<$Res> get dailyReminder;@override $BudgetAlertSettingsCopyWith<$Res> get budgetAlerts;

}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weeklySummary = null,Object? dailyReminder = null,Object? budgetAlerts = null,}) {
  return _then(_NotificationPreferences(
weeklySummary: null == weeklySummary ? _self.weeklySummary : weeklySummary // ignore: cast_nullable_to_non_nullable
as WeeklySummarySettings,dailyReminder: null == dailyReminder ? _self.dailyReminder : dailyReminder // ignore: cast_nullable_to_non_nullable
as DailyReminderSettings,budgetAlerts: null == budgetAlerts ? _self.budgetAlerts : budgetAlerts // ignore: cast_nullable_to_non_nullable
as BudgetAlertSettings,
  ));
}

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklySummarySettingsCopyWith<$Res> get weeklySummary {
  
  return $WeeklySummarySettingsCopyWith<$Res>(_self.weeklySummary, (value) {
    return _then(_self.copyWith(weeklySummary: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyReminderSettingsCopyWith<$Res> get dailyReminder {
  
  return $DailyReminderSettingsCopyWith<$Res>(_self.dailyReminder, (value) {
    return _then(_self.copyWith(dailyReminder: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetAlertSettingsCopyWith<$Res> get budgetAlerts {
  
  return $BudgetAlertSettingsCopyWith<$Res>(_self.budgetAlerts, (value) {
    return _then(_self.copyWith(budgetAlerts: value));
  });
}
}


/// @nodoc
mixin _$WeeklySummarySettings {

 bool get enabled; String get dayOfWeek; String get time;
/// Create a copy of WeeklySummarySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklySummarySettingsCopyWith<WeeklySummarySettings> get copyWith => _$WeeklySummarySettingsCopyWithImpl<WeeklySummarySettings>(this as WeeklySummarySettings, _$identity);

  /// Serializes this WeeklySummarySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklySummarySettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,dayOfWeek,time);

@override
String toString() {
  return 'WeeklySummarySettings(enabled: $enabled, dayOfWeek: $dayOfWeek, time: $time)';
}


}

/// @nodoc
abstract mixin class $WeeklySummarySettingsCopyWith<$Res>  {
  factory $WeeklySummarySettingsCopyWith(WeeklySummarySettings value, $Res Function(WeeklySummarySettings) _then) = _$WeeklySummarySettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, String dayOfWeek, String time
});




}
/// @nodoc
class _$WeeklySummarySettingsCopyWithImpl<$Res>
    implements $WeeklySummarySettingsCopyWith<$Res> {
  _$WeeklySummarySettingsCopyWithImpl(this._self, this._then);

  final WeeklySummarySettings _self;
  final $Res Function(WeeklySummarySettings) _then;

/// Create a copy of WeeklySummarySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? dayOfWeek = null,Object? time = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WeeklySummarySettings implements WeeklySummarySettings {
  const _WeeklySummarySettings({required this.enabled, required this.dayOfWeek, required this.time});
  factory _WeeklySummarySettings.fromJson(Map<String, dynamic> json) => _$WeeklySummarySettingsFromJson(json);

@override final  bool enabled;
@override final  String dayOfWeek;
@override final  String time;

/// Create a copy of WeeklySummarySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklySummarySettingsCopyWith<_WeeklySummarySettings> get copyWith => __$WeeklySummarySettingsCopyWithImpl<_WeeklySummarySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklySummarySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklySummarySettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,dayOfWeek,time);

@override
String toString() {
  return 'WeeklySummarySettings(enabled: $enabled, dayOfWeek: $dayOfWeek, time: $time)';
}


}

/// @nodoc
abstract mixin class _$WeeklySummarySettingsCopyWith<$Res> implements $WeeklySummarySettingsCopyWith<$Res> {
  factory _$WeeklySummarySettingsCopyWith(_WeeklySummarySettings value, $Res Function(_WeeklySummarySettings) _then) = __$WeeklySummarySettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String dayOfWeek, String time
});




}
/// @nodoc
class __$WeeklySummarySettingsCopyWithImpl<$Res>
    implements _$WeeklySummarySettingsCopyWith<$Res> {
  __$WeeklySummarySettingsCopyWithImpl(this._self, this._then);

  final _WeeklySummarySettings _self;
  final $Res Function(_WeeklySummarySettings) _then;

/// Create a copy of WeeklySummarySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? dayOfWeek = null,Object? time = null,}) {
  return _then(_WeeklySummarySettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DailyReminderSettings {

 bool get enabled; String get time;
/// Create a copy of DailyReminderSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyReminderSettingsCopyWith<DailyReminderSettings> get copyWith => _$DailyReminderSettingsCopyWithImpl<DailyReminderSettings>(this as DailyReminderSettings, _$identity);

  /// Serializes this DailyReminderSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyReminderSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,time);

@override
String toString() {
  return 'DailyReminderSettings(enabled: $enabled, time: $time)';
}


}

/// @nodoc
abstract mixin class $DailyReminderSettingsCopyWith<$Res>  {
  factory $DailyReminderSettingsCopyWith(DailyReminderSettings value, $Res Function(DailyReminderSettings) _then) = _$DailyReminderSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, String time
});




}
/// @nodoc
class _$DailyReminderSettingsCopyWithImpl<$Res>
    implements $DailyReminderSettingsCopyWith<$Res> {
  _$DailyReminderSettingsCopyWithImpl(this._self, this._then);

  final DailyReminderSettings _self;
  final $Res Function(DailyReminderSettings) _then;

/// Create a copy of DailyReminderSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DailyReminderSettings implements DailyReminderSettings {
  const _DailyReminderSettings({required this.enabled, required this.time});
  factory _DailyReminderSettings.fromJson(Map<String, dynamic> json) => _$DailyReminderSettingsFromJson(json);

@override final  bool enabled;
@override final  String time;

/// Create a copy of DailyReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyReminderSettingsCopyWith<_DailyReminderSettings> get copyWith => __$DailyReminderSettingsCopyWithImpl<_DailyReminderSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyReminderSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyReminderSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,time);

@override
String toString() {
  return 'DailyReminderSettings(enabled: $enabled, time: $time)';
}


}

/// @nodoc
abstract mixin class _$DailyReminderSettingsCopyWith<$Res> implements $DailyReminderSettingsCopyWith<$Res> {
  factory _$DailyReminderSettingsCopyWith(_DailyReminderSettings value, $Res Function(_DailyReminderSettings) _then) = __$DailyReminderSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String time
});




}
/// @nodoc
class __$DailyReminderSettingsCopyWithImpl<$Res>
    implements _$DailyReminderSettingsCopyWith<$Res> {
  __$DailyReminderSettingsCopyWithImpl(this._self, this._then);

  final _DailyReminderSettings _self;
  final $Res Function(_DailyReminderSettings) _then;

/// Create a copy of DailyReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(_DailyReminderSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BudgetAlertSettings {

 bool get enabled; int get weeklyThreshold; int get monthlyThreshold;
/// Create a copy of BudgetAlertSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetAlertSettingsCopyWith<BudgetAlertSettings> get copyWith => _$BudgetAlertSettingsCopyWithImpl<BudgetAlertSettings>(this as BudgetAlertSettings, _$identity);

  /// Serializes this BudgetAlertSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.weeklyThreshold, weeklyThreshold) || other.weeklyThreshold == weeklyThreshold)&&(identical(other.monthlyThreshold, monthlyThreshold) || other.monthlyThreshold == monthlyThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,weeklyThreshold,monthlyThreshold);

@override
String toString() {
  return 'BudgetAlertSettings(enabled: $enabled, weeklyThreshold: $weeklyThreshold, monthlyThreshold: $monthlyThreshold)';
}


}

/// @nodoc
abstract mixin class $BudgetAlertSettingsCopyWith<$Res>  {
  factory $BudgetAlertSettingsCopyWith(BudgetAlertSettings value, $Res Function(BudgetAlertSettings) _then) = _$BudgetAlertSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, int weeklyThreshold, int monthlyThreshold
});




}
/// @nodoc
class _$BudgetAlertSettingsCopyWithImpl<$Res>
    implements $BudgetAlertSettingsCopyWith<$Res> {
  _$BudgetAlertSettingsCopyWithImpl(this._self, this._then);

  final BudgetAlertSettings _self;
  final $Res Function(BudgetAlertSettings) _then;

/// Create a copy of BudgetAlertSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? weeklyThreshold = null,Object? monthlyThreshold = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,weeklyThreshold: null == weeklyThreshold ? _self.weeklyThreshold : weeklyThreshold // ignore: cast_nullable_to_non_nullable
as int,monthlyThreshold: null == monthlyThreshold ? _self.monthlyThreshold : monthlyThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BudgetAlertSettings implements BudgetAlertSettings {
  const _BudgetAlertSettings({required this.enabled, required this.weeklyThreshold, required this.monthlyThreshold});
  factory _BudgetAlertSettings.fromJson(Map<String, dynamic> json) => _$BudgetAlertSettingsFromJson(json);

@override final  bool enabled;
@override final  int weeklyThreshold;
@override final  int monthlyThreshold;

/// Create a copy of BudgetAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetAlertSettingsCopyWith<_BudgetAlertSettings> get copyWith => __$BudgetAlertSettingsCopyWithImpl<_BudgetAlertSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetAlertSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.weeklyThreshold, weeklyThreshold) || other.weeklyThreshold == weeklyThreshold)&&(identical(other.monthlyThreshold, monthlyThreshold) || other.monthlyThreshold == monthlyThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,weeklyThreshold,monthlyThreshold);

@override
String toString() {
  return 'BudgetAlertSettings(enabled: $enabled, weeklyThreshold: $weeklyThreshold, monthlyThreshold: $monthlyThreshold)';
}


}

/// @nodoc
abstract mixin class _$BudgetAlertSettingsCopyWith<$Res> implements $BudgetAlertSettingsCopyWith<$Res> {
  factory _$BudgetAlertSettingsCopyWith(_BudgetAlertSettings value, $Res Function(_BudgetAlertSettings) _then) = __$BudgetAlertSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int weeklyThreshold, int monthlyThreshold
});




}
/// @nodoc
class __$BudgetAlertSettingsCopyWithImpl<$Res>
    implements _$BudgetAlertSettingsCopyWith<$Res> {
  __$BudgetAlertSettingsCopyWithImpl(this._self, this._then);

  final _BudgetAlertSettings _self;
  final $Res Function(_BudgetAlertSettings) _then;

/// Create a copy of BudgetAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? weeklyThreshold = null,Object? monthlyThreshold = null,}) {
  return _then(_BudgetAlertSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,weeklyThreshold: null == weeklyThreshold ? _self.weeklyThreshold : weeklyThreshold // ignore: cast_nullable_to_non_nullable
as int,monthlyThreshold: null == monthlyThreshold ? _self.monthlyThreshold : monthlyThreshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
