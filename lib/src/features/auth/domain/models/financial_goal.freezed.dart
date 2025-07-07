// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialGoal {

 String get id; String get type; double get amount; String get currency; String? get period; DateTime? get targetDate; DateTime get createdAt;
/// Create a copy of FinancialGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialGoalCopyWith<FinancialGoal> get copyWith => _$FinancialGoalCopyWithImpl<FinancialGoal>(this as FinancialGoal, _$identity);

  /// Serializes this FinancialGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.period, period) || other.period == period)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,currency,period,targetDate,createdAt);

@override
String toString() {
  return 'FinancialGoal(id: $id, type: $type, amount: $amount, currency: $currency, period: $period, targetDate: $targetDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FinancialGoalCopyWith<$Res>  {
  factory $FinancialGoalCopyWith(FinancialGoal value, $Res Function(FinancialGoal) _then) = _$FinancialGoalCopyWithImpl;
@useResult
$Res call({
 String id, String type, double amount, String currency, String? period, DateTime? targetDate, DateTime createdAt
});




}
/// @nodoc
class _$FinancialGoalCopyWithImpl<$Res>
    implements $FinancialGoalCopyWith<$Res> {
  _$FinancialGoalCopyWithImpl(this._self, this._then);

  final FinancialGoal _self;
  final $Res Function(FinancialGoal) _then;

/// Create a copy of FinancialGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? period = freezed,Object? targetDate = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FinancialGoal implements FinancialGoal {
  const _FinancialGoal({required this.id, required this.type, required this.amount, required this.currency, this.period, this.targetDate, required this.createdAt});
  factory _FinancialGoal.fromJson(Map<String, dynamic> json) => _$FinancialGoalFromJson(json);

@override final  String id;
@override final  String type;
@override final  double amount;
@override final  String currency;
@override final  String? period;
@override final  DateTime? targetDate;
@override final  DateTime createdAt;

/// Create a copy of FinancialGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialGoalCopyWith<_FinancialGoal> get copyWith => __$FinancialGoalCopyWithImpl<_FinancialGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.period, period) || other.period == period)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,currency,period,targetDate,createdAt);

@override
String toString() {
  return 'FinancialGoal(id: $id, type: $type, amount: $amount, currency: $currency, period: $period, targetDate: $targetDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FinancialGoalCopyWith<$Res> implements $FinancialGoalCopyWith<$Res> {
  factory _$FinancialGoalCopyWith(_FinancialGoal value, $Res Function(_FinancialGoal) _then) = __$FinancialGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, double amount, String currency, String? period, DateTime? targetDate, DateTime createdAt
});




}
/// @nodoc
class __$FinancialGoalCopyWithImpl<$Res>
    implements _$FinancialGoalCopyWith<$Res> {
  __$FinancialGoalCopyWithImpl(this._self, this._then);

  final _FinancialGoal _self;
  final $Res Function(_FinancialGoal) _then;

/// Create a copy of FinancialGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? period = freezed,Object? targetDate = freezed,Object? createdAt = null,}) {
  return _then(_FinancialGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
