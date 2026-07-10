import 'package:uuid/uuid.dart';
import 'rule_condition.dart';
import 'rule_action.dart';

/// Represents a history log of a rule applied to a transaction.
///
/// Direct port of `domain/model/rule/RuleApplication.kt`.
class RuleApplication {
  final String id;
  final String ruleId;
  final String ruleName;
  final String transactionId;
  final List<FieldModification> fieldsModified;
  final DateTime appliedAt;

  RuleApplication({
    String? id,
    required this.ruleId,
    required this.ruleName,
    required this.transactionId,
    required this.fieldsModified,
    DateTime? appliedAt,
  })  : id = id ?? const Uuid().v4(),
        appliedAt = appliedAt ?? DateTime.now();

  factory RuleApplication.fromJson(Map<String, dynamic> json) {
    return RuleApplication(
      id: json['id'] as String?,
      ruleId: json['ruleId'] as String? ?? '',
      ruleName: json['ruleName'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      fieldsModified: (json['fieldsModified'] as List<dynamic>?)
              ?.map((e) => FieldModification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      appliedAt: json['appliedAt'] != null ? DateTime.parse(json['appliedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruleId': ruleId,
      'ruleName': ruleName,
      'transactionId': transactionId,
      'fieldsModified': fieldsModified.map((e) => e.toJson()).toList(),
      'appliedAt': appliedAt.toIso8601String(),
    };
  }
}

/// Description of a specific field modification.
///
/// Direct port of `domain/model/rule/FieldModification`.
class FieldModification {
  final TransactionField field;
  final String? oldValue;
  final String? newValue;
  final ActionType actionType;

  const FieldModification({
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.actionType,
  });

  factory FieldModification.fromJson(Map<String, dynamic> json) {
    return FieldModification(
      field: TransactionField.values.byName(json['field'] as String),
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      actionType: ActionType.values.byName(json['actionType'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field.name,
      'oldValue': oldValue,
      'newValue': newValue,
      'actionType': actionType.name,
    };
  }
}
