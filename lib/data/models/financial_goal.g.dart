// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialGoal _$FinancialGoalFromJson(Map<String, dynamic> json) =>
    _FinancialGoal(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      period: json['period'] as String?,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FinancialGoalToJson(_FinancialGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'period': instance.period,
      'targetDate': instance.targetDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
