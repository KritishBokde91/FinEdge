import 'package:flutter/material.dart';

/// Custom theme properties for transaction, budgeting, subscription, and financial goal tracking.
class FinanceThemeExtension extends ThemeExtension<FinanceThemeExtension> {
  final Color incomeColor;
  final Color expenseColor;
  final Color budgetProgressColor;
  final Color budgetLimitExceededColor;
  final Color subscriptionCardColor;

  const FinanceThemeExtension({
    required this.incomeColor,
    required this.expenseColor,
    required this.budgetProgressColor,
    required this.budgetLimitExceededColor,
    required this.subscriptionCardColor,
  });

  @override
  FinanceThemeExtension copyWith({
    Color? incomeColor,
    Color? expenseColor,
    Color? budgetProgressColor,
    Color? budgetLimitExceededColor,
    Color? subscriptionCardColor,
  }) {
    return FinanceThemeExtension(
      incomeColor: incomeColor ?? this.incomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      budgetProgressColor: budgetProgressColor ?? this.budgetProgressColor,
      budgetLimitExceededColor:
          budgetLimitExceededColor ?? this.budgetLimitExceededColor,
      subscriptionCardColor:
          subscriptionCardColor ?? this.subscriptionCardColor,
    );
  }

  @override
  FinanceThemeExtension lerp(
    ThemeExtension<FinanceThemeExtension>? other,
    double t,
  ) {
    if (other is! FinanceThemeExtension) return this;
    return FinanceThemeExtension(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t) ?? incomeColor,
      expenseColor:
          Color.lerp(expenseColor, other.expenseColor, t) ?? expenseColor,
      budgetProgressColor:
          Color.lerp(budgetProgressColor, other.budgetProgressColor, t) ??
          budgetProgressColor,
      budgetLimitExceededColor:
          Color.lerp(
            budgetLimitExceededColor,
            other.budgetLimitExceededColor,
            t,
          ) ??
          budgetLimitExceededColor,
      subscriptionCardColor:
          Color.lerp(subscriptionCardColor, other.subscriptionCardColor, t) ??
          subscriptionCardColor,
    );
  }
}
