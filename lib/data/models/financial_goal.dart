import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_goal.freezed.dart';
part 'financial_goal.g.dart';

@freezed
abstract class FinancialGoal with _$FinancialGoal {
  const factory FinancialGoal({
    required String id,
    required String type,
    required double amount,
    required String currency,
    String? period,
    DateTime? targetDate,
    required DateTime createdAt,
  }) = _FinancialGoal;

  factory FinancialGoal.fromJson(Map<String, dynamic> json) =>
      _$FinancialGoalFromJson(json);
}

// Extension for helper methods (since we can't add them directly to abstract classes)
extension FinancialGoalExtension on FinancialGoal {
  bool get isSavingsGoal => type == 'save_amount';
  
  bool get isSpendingLimitGoal => type == 'spend_less_than';
  
  String get description {
    if (isSavingsGoal) {
      return 'Save $currency ${amount.toStringAsFixed(0)} by ${targetDate?.toLocal().toString().split(' ')[0] ?? 'target date'}';
    } else {
      return 'Spend less than $currency ${amount.toStringAsFixed(0)} ${period ?? 'monthly'}';
    }
  }
}