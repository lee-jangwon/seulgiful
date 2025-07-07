import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_settings.freezed.dart';
part 'budget_settings.g.dart';

@freezed
abstract class BudgetSettings with _$BudgetSettings {
  const factory BudgetSettings({
    double? weeklyBudget,
    double? monthlyBudget,
    required String budgetStartDay,
  }) = _BudgetSettings;

  factory BudgetSettings.fromJson(Map<String, dynamic> json) =>
      _$BudgetSettingsFromJson(json);

  factory BudgetSettings.defaultSettings() => const BudgetSettings(
    weeklyBudget: null,
    monthlyBudget: null,
    budgetStartDay: 'monday',
  );
}