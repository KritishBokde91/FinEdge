/// Enum representing the transaction fields that can be evaluated in rules.
enum TransactionField {
  amount,                  // Transaction amount
  type,                    // INCOME, EXPENSE, or TRANSFER
  category,                // Transaction category
  merchant,                // Merchant/vendor name
  narration,               // Description/notes
  smsText,                 // Original SMS text
  bankName,                // Bank name from SMS
  transactionHour,        // Hour (00-23)
  transactionTime,        // Time as HH:mm
  transactionDayOfWeek, // 1=Monday .. 7=Sunday
  transactionDayOfMonth,// 01-31
  transactionDate,        // yyyy-MM-dd
  /// Composite key "BankName||Last4" scoping rules to a specific account.
  /// Supports only [ConditionOperator.equals] and [ConditionOperator.notEquals].
  account
}

/// Enum representing the operators available for rule conditions.
enum ConditionOperator {
  equals,
  notEquals,
  contains,
  notContains,
  startsWith,
  endsWith,
  lessThan,
  greaterThan,
  lessThanOrEqual,
  greaterThanOrEqual,
  operatorIn, // 'in' is a reserved keyword in Dart
  operatorNotIn, // 'not_in'
  regexMatches,
  isEmpty,
  isNotEmpty
}

/// Enum representing the logical operators to combine conditions.
enum LogicalOperator {
  and,
  or
}

/// Condition defining a matching rule on a Transaction.
///
/// Direct port of `domain/model/rule/RuleCondition.kt`.
class RuleCondition {
  final TransactionField field;
  final ConditionOperator operator;
  final String value;
  final LogicalOperator logicalOperator;

  const RuleCondition({
    required this.field,
    required this.operator,
    required this.value,
    this.logicalOperator = LogicalOperator.and,
  });

  bool validate() {
    if (value.trim().isEmpty &&
        operator != ConditionOperator.isEmpty &&
        operator != ConditionOperator.isNotEmpty) {
      return false;
    }

    switch (field) {
      case TransactionField.amount:
        switch (operator) {
          case ConditionOperator.lessThan:
          case ConditionOperator.greaterThan:
          case ConditionOperator.lessThanOrEqual:
          case ConditionOperator.greaterThanOrEqual:
            return double.tryParse(value) != null;
          default:
            return true;
        }

      case TransactionField.transactionHour:
        final hour = int.tryParse(value);
        return hour != null && hour >= 0 && hour <= 23;

      case TransactionField.transactionTime:
        return RegExp(r'^\d{2}:\d{2}$').hasMatch(value);

      case TransactionField.transactionDayOfWeek:
        switch (operator) {
          case ConditionOperator.operatorIn:
          case ConditionOperator.operatorNotIn:
            return value.split(',').every((v) {
              final d = int.tryParse(v.trim());
              return d != null && d >= 1 && d <= 7;
            });
          default:
            final d = int.tryParse(value);
            return d != null && d >= 1 && d <= 7;
        }

      case TransactionField.transactionDayOfMonth:
        switch (operator) {
          case ConditionOperator.operatorIn:
          case ConditionOperator.operatorNotIn:
            return value.split(',').every((v) {
              final d = int.tryParse(v.trim());
              return d != null && d >= 1 && d <= 31;
            });
          default:
            final d = int.tryParse(value);
            return d != null && d >= 1 && d <= 31;
        }

      case TransactionField.account:
        final parts = value.split('||');
        return parts.length == 2 && parts[0].trim().isNotEmpty && parts[1].trim().isNotEmpty;

      default:
        return true;
    }
  }

  factory RuleCondition.fromJson(Map<String, dynamic> json) {
    return RuleCondition(
      field: TransactionField.values.byName(json['field'] as String),
      operator: ConditionOperator.values.byName(json['operator'] as String),
      value: json['value'] as String? ?? '',
      logicalOperator: json['logicalOperator'] != null
          ? LogicalOperator.values.byName(json['logicalOperator'] as String)
          : LogicalOperator.and,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field.name,
      'operator': operator.name,
      'value': value,
      'logicalOperator': logicalOperator.name,
    };
  }
}
