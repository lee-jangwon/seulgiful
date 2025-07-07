// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetSettings {

 double? get weeklyBudget; double? get monthlyBudget; String get budgetStartDay;
/// Create a copy of BudgetSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetSettingsCopyWith<BudgetSettings> get copyWith => _$BudgetSettingsCopyWithImpl<BudgetSettings>(this as BudgetSettings, _$identity);

  /// Serializes this BudgetSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetSettings&&(identical(other.weeklyBudget, weeklyBudget) || other.weeklyBudget == weeklyBudget)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.budgetStartDay, budgetStartDay) || other.budgetStartDay == budgetStartDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklyBudget,monthlyBudget,budgetStartDay);

@override
String toString() {
  return 'BudgetSettings(weeklyBudget: $weeklyBudget, monthlyBudget: $monthlyBudget, budgetStartDay: $budgetStartDay)';
}


}

/// @nodoc
abstract mixin class $BudgetSettingsCopyWith<$Res>  {
  factory $BudgetSettingsCopyWith(BudgetSettings value, $Res Function(BudgetSettings) _then) = _$BudgetSettingsCopyWithImpl;
@useResult
$Res call({
 double? weeklyBudget, double? monthlyBudget, String budgetStartDay
});




}
/// @nodoc
class _$BudgetSettingsCopyWithImpl<$Res>
    implements $BudgetSettingsCopyWith<$Res> {
  _$BudgetSettingsCopyWithImpl(this._self, this._then);

  final BudgetSettings _self;
  final $Res Function(BudgetSettings) _then;

/// Create a copy of BudgetSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weeklyBudget = freezed,Object? monthlyBudget = freezed,Object? budgetStartDay = null,}) {
  return _then(_self.copyWith(
weeklyBudget: freezed == weeklyBudget ? _self.weeklyBudget : weeklyBudget // ignore: cast_nullable_to_non_nullable
as double?,monthlyBudget: freezed == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double?,budgetStartDay: null == budgetStartDay ? _self.budgetStartDay : budgetStartDay // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BudgetSettings implements BudgetSettings {
  const _BudgetSettings({this.weeklyBudget, this.monthlyBudget, required this.budgetStartDay});
  factory _BudgetSettings.fromJson(Map<String, dynamic> json) => _$BudgetSettingsFromJson(json);

@override final  double? weeklyBudget;
@override final  double? monthlyBudget;
@override final  String budgetStartDay;

/// Create a copy of BudgetSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetSettingsCopyWith<_BudgetSettings> get copyWith => __$BudgetSettingsCopyWithImpl<_BudgetSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetSettings&&(identical(other.weeklyBudget, weeklyBudget) || other.weeklyBudget == weeklyBudget)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.budgetStartDay, budgetStartDay) || other.budgetStartDay == budgetStartDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklyBudget,monthlyBudget,budgetStartDay);

@override
String toString() {
  return 'BudgetSettings(weeklyBudget: $weeklyBudget, monthlyBudget: $monthlyBudget, budgetStartDay: $budgetStartDay)';
}


}

/// @nodoc
abstract mixin class _$BudgetSettingsCopyWith<$Res> implements $BudgetSettingsCopyWith<$Res> {
  factory _$BudgetSettingsCopyWith(_BudgetSettings value, $Res Function(_BudgetSettings) _then) = __$BudgetSettingsCopyWithImpl;
@override @useResult
$Res call({
 double? weeklyBudget, double? monthlyBudget, String budgetStartDay
});




}
/// @nodoc
class __$BudgetSettingsCopyWithImpl<$Res>
    implements _$BudgetSettingsCopyWith<$Res> {
  __$BudgetSettingsCopyWithImpl(this._self, this._then);

  final _BudgetSettings _self;
  final $Res Function(_BudgetSettings) _then;

/// Create a copy of BudgetSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weeklyBudget = freezed,Object? monthlyBudget = freezed,Object? budgetStartDay = null,}) {
  return _then(_BudgetSettings(
weeklyBudget: freezed == weeklyBudget ? _self.weeklyBudget : weeklyBudget // ignore: cast_nullable_to_non_nullable
as double?,monthlyBudget: freezed == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double?,budgetStartDay: null == budgetStartDay ? _self.budgetStartDay : budgetStartDay // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
