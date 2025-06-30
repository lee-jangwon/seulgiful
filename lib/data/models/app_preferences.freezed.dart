// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppPreferences {

 bool get currencyConversionWarnings; bool get quickAddEnabled; String get defaultTransactionTime;
/// Create a copy of AppPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPreferencesCopyWith<AppPreferences> get copyWith => _$AppPreferencesCopyWithImpl<AppPreferences>(this as AppPreferences, _$identity);

  /// Serializes this AppPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPreferences&&(identical(other.currencyConversionWarnings, currencyConversionWarnings) || other.currencyConversionWarnings == currencyConversionWarnings)&&(identical(other.quickAddEnabled, quickAddEnabled) || other.quickAddEnabled == quickAddEnabled)&&(identical(other.defaultTransactionTime, defaultTransactionTime) || other.defaultTransactionTime == defaultTransactionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyConversionWarnings,quickAddEnabled,defaultTransactionTime);

@override
String toString() {
  return 'AppPreferences(currencyConversionWarnings: $currencyConversionWarnings, quickAddEnabled: $quickAddEnabled, defaultTransactionTime: $defaultTransactionTime)';
}


}

/// @nodoc
abstract mixin class $AppPreferencesCopyWith<$Res>  {
  factory $AppPreferencesCopyWith(AppPreferences value, $Res Function(AppPreferences) _then) = _$AppPreferencesCopyWithImpl;
@useResult
$Res call({
 bool currencyConversionWarnings, bool quickAddEnabled, String defaultTransactionTime
});




}
/// @nodoc
class _$AppPreferencesCopyWithImpl<$Res>
    implements $AppPreferencesCopyWith<$Res> {
  _$AppPreferencesCopyWithImpl(this._self, this._then);

  final AppPreferences _self;
  final $Res Function(AppPreferences) _then;

/// Create a copy of AppPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currencyConversionWarnings = null,Object? quickAddEnabled = null,Object? defaultTransactionTime = null,}) {
  return _then(_self.copyWith(
currencyConversionWarnings: null == currencyConversionWarnings ? _self.currencyConversionWarnings : currencyConversionWarnings // ignore: cast_nullable_to_non_nullable
as bool,quickAddEnabled: null == quickAddEnabled ? _self.quickAddEnabled : quickAddEnabled // ignore: cast_nullable_to_non_nullable
as bool,defaultTransactionTime: null == defaultTransactionTime ? _self.defaultTransactionTime : defaultTransactionTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppPreferences implements AppPreferences {
  const _AppPreferences({required this.currencyConversionWarnings, required this.quickAddEnabled, required this.defaultTransactionTime});
  factory _AppPreferences.fromJson(Map<String, dynamic> json) => _$AppPreferencesFromJson(json);

@override final  bool currencyConversionWarnings;
@override final  bool quickAddEnabled;
@override final  String defaultTransactionTime;

/// Create a copy of AppPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPreferencesCopyWith<_AppPreferences> get copyWith => __$AppPreferencesCopyWithImpl<_AppPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPreferences&&(identical(other.currencyConversionWarnings, currencyConversionWarnings) || other.currencyConversionWarnings == currencyConversionWarnings)&&(identical(other.quickAddEnabled, quickAddEnabled) || other.quickAddEnabled == quickAddEnabled)&&(identical(other.defaultTransactionTime, defaultTransactionTime) || other.defaultTransactionTime == defaultTransactionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currencyConversionWarnings,quickAddEnabled,defaultTransactionTime);

@override
String toString() {
  return 'AppPreferences(currencyConversionWarnings: $currencyConversionWarnings, quickAddEnabled: $quickAddEnabled, defaultTransactionTime: $defaultTransactionTime)';
}


}

/// @nodoc
abstract mixin class _$AppPreferencesCopyWith<$Res> implements $AppPreferencesCopyWith<$Res> {
  factory _$AppPreferencesCopyWith(_AppPreferences value, $Res Function(_AppPreferences) _then) = __$AppPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool currencyConversionWarnings, bool quickAddEnabled, String defaultTransactionTime
});




}
/// @nodoc
class __$AppPreferencesCopyWithImpl<$Res>
    implements _$AppPreferencesCopyWith<$Res> {
  __$AppPreferencesCopyWithImpl(this._self, this._then);

  final _AppPreferences _self;
  final $Res Function(_AppPreferences) _then;

/// Create a copy of AppPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currencyConversionWarnings = null,Object? quickAddEnabled = null,Object? defaultTransactionTime = null,}) {
  return _then(_AppPreferences(
currencyConversionWarnings: null == currencyConversionWarnings ? _self.currencyConversionWarnings : currencyConversionWarnings // ignore: cast_nullable_to_non_nullable
as bool,quickAddEnabled: null == quickAddEnabled ? _self.quickAddEnabled : quickAddEnabled // ignore: cast_nullable_to_non_nullable
as bool,defaultTransactionTime: null == defaultTransactionTime ? _self.defaultTransactionTime : defaultTransactionTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
