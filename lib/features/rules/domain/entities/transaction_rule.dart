import 'package:uuid/uuid.dart';
import 'rule_condition.dart';
import 'rule_action.dart';

/// Representation of a custom user rule.
///
/// Direct port of `domain/model/rule/TransactionRule.kt`.
class TransactionRule {
  final String id;
  final String name;
  final String? description;
  final int priority; // Lower number = higher priority
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;
  final bool isActive;
  final bool isSystemTemplate; // System rules can't be deleted
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionRule({
    String? id,
    required this.name,
    this.description,
    this.priority = 100,
    required this.conditions,
    required this.actions,
    this.isActive = true,
    this.isSystemTemplate = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool validate() {
    return name.trim().isNotEmpty && conditions.isNotEmpty && actions.isNotEmpty;
  }

  TransactionRule copyWith({
    String? id,
    String? name,
    String? description,
    int? priority,
    List<RuleCondition>? conditions,
    List<RuleAction>? actions,
    bool? isActive,
    bool? isSystemTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionRule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      isActive: isActive ?? this.isActive,
      isSystemTemplate: isSystemTemplate ?? this.isSystemTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TransactionRule.fromJson(Map<String, dynamic> json) {
    return TransactionRule(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      priority: json['priority'] as int? ?? 100,
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => RuleCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => RuleAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      isSystemTemplate: json['isSystemTemplate'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'priority': priority,
      'conditions': conditions.map((e) => e.toJson()).toList(),
      'actions': actions.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'isSystemTemplate': isSystemTemplate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
