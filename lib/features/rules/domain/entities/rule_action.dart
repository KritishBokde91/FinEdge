import 'rule_condition.dart';

/// Enum representing types of actions a rule can take.
enum ActionType {
  set,        // Set field to value
  append,     // Append value to field
  prepend,    // Prepend value to field
  clear,      // Clear field
  addTag,     // Add a tag
  removeTag,  // Remove a tag
  block       // Block the transaction from being saved
}

/// Action to execute on matching a transaction rule.
///
/// Direct port of `domain/model/rule/RuleAction.kt`.
class RuleAction {
  final TransactionField field;
  final ActionType actionType;
  final String value;

  const RuleAction({
    required this.field,
    required this.actionType,
    required this.value,
  });

  bool validate() {
    switch (actionType) {
      case ActionType.set:
      case ActionType.append:
      case ActionType.prepend:
      case ActionType.addTag:
      case ActionType.removeTag:
        return value.trim().isNotEmpty;
      case ActionType.clear:
      case ActionType.block:
        return true;
    }
  }

  factory RuleAction.fromJson(Map<String, dynamic> json) {
    return RuleAction(
      field: TransactionField.values.byName(json['field'] as String),
      actionType: ActionType.values.byName(json['actionType'] as String),
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field.name,
      'actionType': actionType.name,
      'value': value,
    };
  }
}
