// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetSettings _$BudgetSettingsFromJson(Map<String, dynamic> json) =>
    _BudgetSettings(
      weeklyBudget: (json['weeklyBudget'] as num?)?.toDouble(),
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble(),
      budgetStartDay: json['budgetStartDay'] as String,
    );

Map<String, dynamic> _$BudgetSettingsToJson(_BudgetSettings instance) =>
    <String, dynamic>{
      'weeklyBudget': instance.weeklyBudget,
      'monthlyBudget': instance.monthlyBudget,
      'budgetStartDay': instance.budgetStartDay,
    };
