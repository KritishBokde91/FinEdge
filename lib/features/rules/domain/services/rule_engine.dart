import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';
import '../entities/rule_condition.dart';
import '../entities/rule_action.dart';
import '../entities/transaction_rule.dart';
import '../entities/rule_application.dart';

/// Rule evaluation engine.
///
/// Direct port of `domain/service/RuleEngine.kt`.
class RuleEngine {
  const RuleEngine();

  (TransactionEntity, List<RuleApplication>) evaluateRules(
    TransactionEntity transaction,
    String? smsText,
    List<TransactionRule> rules,
  ) {
    final sortedRules = rules
        .where((r) => r.isActive)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));

    var modifiedTransaction = transaction;
    final applications = <RuleApplication>[];

    for (final rule in sortedRules) {
      if (evaluateConditions(modifiedTransaction, smsText, rule.conditions)) {
        final (newTransaction, fieldMods) = applyActions(modifiedTransaction, rule.actions);

        if (fieldMods.isNotEmpty) {
          modifiedTransaction = newTransaction;
          applications.add(
            RuleApplication(
              ruleId: rule.id,
              ruleName: rule.name,
              transactionId: transaction.id,
              fieldsModified: fieldMods,
              appliedAt: DateTime.now(),
            ),
          );
        }
      }
    }

    return (modifiedTransaction, applications);
  }

  /// Evaluates rules for a specific transaction type.
  /// Pre-filters rules based on transaction type as an optimization.
  (TransactionEntity, List<RuleApplication>) evaluateRulesForType(
    TransactionEntity transaction,
    String? smsText,
    List<TransactionRule> rules,
    bool isIncome,
  ) {
    final typeStr = isIncome ? 'INCOME' : 'EXPENSE';

    final applicableRules = rules.where((rule) {
      final hasTypeCondition = rule.conditions.any((c) => c.field == TransactionField.type);
      final hasOrLogic = rule.conditions.any((c) => c.logicalOperator == LogicalOperator.or);
      if (!hasTypeCondition || hasOrLogic) {
        return true;
      } else {
        return rule.conditions.any((condition) {
          if (condition.field != TransactionField.type) return false;

          switch (condition.operator) {
            case ConditionOperator.equals:
              return condition.value.toUpperCase() == typeStr;
            case ConditionOperator.operatorIn:
              return condition.value
                  .split(',')
                  .map((e) => e.trim().toUpperCase())
                  .contains(typeStr);
            case ConditionOperator.notEquals:
              return condition.value.toUpperCase() != typeStr;
            case ConditionOperator.operatorNotIn:
              return !condition.value
                  .split(',')
                  .map((e) => e.trim().toUpperCase())
                  .contains(typeStr);
            default:
              return false;
          }
        });
      }
    }).toList();

    return evaluateRules(transaction, smsText, applicableRules);
  }

  /// Checks if a transaction should be blocked based on blocking rules.
  TransactionRule? shouldBlockTransaction(
    TransactionEntity transaction,
    String? smsText,
    List<TransactionRule> rules,
  ) {
    final blockingRules = rules
        .where((r) => r.isActive)
        .where((r) => r.actions.any((a) => a.actionType == ActionType.block))
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));

    for (final rule in blockingRules) {
      if (evaluateConditions(transaction, smsText, rule.conditions)) {
        return rule;
      }
    }

    return null;
  }

  bool evaluateConditions(
    TransactionEntity transaction,
    String? smsText,
    List<RuleCondition> conditions,
  ) {
    if (conditions.isEmpty) return false;

    var result = evaluateCondition(transaction, smsText, conditions.first);
    for (var i = 1; i < conditions.length; i++) {
      final condition = conditions[i];
      final condResult = evaluateCondition(transaction, smsText, condition);
      switch (condition.logicalOperator) {
        case LogicalOperator.and:
          result = result && condResult;
          break;
        case LogicalOperator.or:
          result = result || condResult;
          break;
      }
    }
    return result;
  }

  bool evaluateCondition(
    TransactionEntity transaction,
    String? smsText,
    RuleCondition condition,
  ) {
    final fieldValue = getFieldValue(transaction, smsText, condition.field);
    final value = condition.value;

    switch (condition.operator) {
      case ConditionOperator.equals:
        return fieldValue.toLowerCase() == value.toLowerCase();
      case ConditionOperator.notEquals:
        if (condition.field == TransactionField.account && fieldValue.isEmpty) return false;
        return fieldValue.toLowerCase() != value.toLowerCase();
      case ConditionOperator.contains:
        return fieldValue.toLowerCase().contains(value.toLowerCase());
      case ConditionOperator.notContains:
        return !fieldValue.toLowerCase().contains(value.toLowerCase());
      case ConditionOperator.startsWith:
        return fieldValue.toLowerCase().startsWith(value.toLowerCase());
      case ConditionOperator.endsWith:
        return fieldValue.toLowerCase().endsWith(value.toLowerCase());
      case ConditionOperator.lessThan:
        return compareNumeric(fieldValue, value) < 0;
      case ConditionOperator.greaterThan:
        return compareNumeric(fieldValue, value) > 0;
      case ConditionOperator.lessThanOrEqual:
        return compareNumeric(fieldValue, value) <= 0;
      case ConditionOperator.greaterThanOrEqual:
        return compareNumeric(fieldValue, value) >= 0;
      case ConditionOperator.operatorIn:
        return value
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .contains(fieldValue.toLowerCase());
      case ConditionOperator.operatorNotIn:
        return !value
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .contains(fieldValue.toLowerCase());
      case ConditionOperator.regexMatches:
        return RegExp(value, caseSensitive: false).hasMatch(fieldValue);
      case ConditionOperator.isEmpty:
        return fieldValue.trim().isEmpty;
      case ConditionOperator.isNotEmpty:
        return fieldValue.trim().isNotEmpty;
    }
  }

  String getFieldValue(
    TransactionEntity transaction,
    String? smsText,
    TransactionField field,
  ) {
    switch (field) {
      case TransactionField.amount:
        return transaction.amount.toString();
      case TransactionField.type:
        return transaction.isIncome ? 'INCOME' : 'EXPENSE';
      case TransactionField.category:
        return transaction.category;
      case TransactionField.merchant:
        return transaction.merchant;
      case TransactionField.narration:
        return ''; // narration or description not directly on TransactionEntity or mapped to empty
      case TransactionField.smsText:
        return smsText ?? '';
      case TransactionField.bankName:
        return transaction.accountSource; // maps bank/source
      case TransactionField.transactionHour:
        return NumberFormat('00').format(transaction.timestamp.hour);
      case TransactionField.transactionTime:
        final h = NumberFormat('00').format(transaction.timestamp.hour);
        final m = NumberFormat('00').format(transaction.timestamp.minute);
        return '$h:$m';
      case TransactionField.transactionDayOfWeek:
        return transaction.timestamp.weekday.toString();
      case TransactionField.transactionDayOfMonth:
        return NumberFormat('00').format(transaction.timestamp.day);
      case TransactionField.transactionDate:
        return DateFormat('yyyy-MM-dd').format(transaction.timestamp);
      case TransactionField.account:
        final bank = transaction.accountSource;
        final last4 = transaction.reference?.length != null && transaction.reference!.length >= 4
            ? transaction.reference!.substring(transaction.reference!.length - 4)
            : null;
        if (last4 != null) {
          return '$bank||$last4';
        }
        return '';
    }
  }

  int compareNumeric(String value1, String value2) {
    final d1 = double.tryParse(value1);
    final d2 = double.tryParse(value2);
    if (d1 != null && d2 != null) {
      return d1.compareTo(d2);
    }
    return value1.compareTo(value2);
  }

  (TransactionEntity, List<FieldModification>) applyActions(
    TransactionEntity transaction,
    List<RuleAction> actions,
  ) {
    var modifiedTransaction = transaction;
    final modifications = <FieldModification>[];

    for (final action in actions) {
      if (action.actionType == ActionType.block) continue;

      final oldValue = getFieldValue(modifiedTransaction, null, action.field);
      final (newTransaction, newValue) = applyAction(modifiedTransaction, action);

      if (oldValue != newValue) {
        modifiedTransaction = newTransaction;
        modifications.add(
          FieldModification(
            field: action.field,
            oldValue: oldValue.isNotEmpty ? oldValue : null,
            newValue: newValue,
            actionType: action.actionType,
          ),
        );
      }
    }

    return (modifiedTransaction, modifications);
  }

  (TransactionEntity, String) applyAction(
    TransactionEntity transaction,
    RuleAction action,
  ) {
    switch (action.field) {
      case TransactionField.category:
        final newValue = action.actionType == ActionType.clear ? '' : action.value;
        return (transaction.copyWith(category: newValue), newValue);

      case TransactionField.merchant:
        var newValue = transaction.merchant;
        switch (action.actionType) {
          case ActionType.set:
            newValue = action.value;
            break;
          case ActionType.append:
            newValue = '${transaction.merchant}${action.value}';
            break;
          case ActionType.prepend:
            newValue = '${action.value}${transaction.merchant}';
            break;
          case ActionType.clear:
            newValue = '';
            break;
          default:
            break;
        }
        return (transaction.copyWith(merchant: newValue), newValue);

      case TransactionField.type:
        var isIncome = transaction.isIncome;
        if (action.actionType == ActionType.set) {
          final valUpper = action.value.toUpperCase();
          if (valUpper == 'INCOME') {
            isIncome = true;
          } else if (valUpper == 'EXPENSE') {
            isIncome = false;
          }
        }
        return (
          transaction.copyWith(isIncome: isIncome),
          isIncome ? 'INCOME' : 'EXPENSE'
        );

      case TransactionField.bankName:
        final newValue = action.actionType == ActionType.clear ? '' : action.value;
        return (transaction.copyWith(accountSource: newValue), newValue);

      default:
        return (transaction, getFieldValue(transaction, null, action.field));
    }
  }

  // ── Serialization Helpers ─────────────────────────────────────────

  String serializeConditions(List<RuleCondition> conditions) {
    return jsonEncode(conditions.map((e) => e.toJson()).toList());
  }

  List<RuleCondition> deserializeConditions(String jsonStr) {
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => RuleCondition.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [];
    }
  }

  String serializeActions(List<RuleAction> actions) {
    return jsonEncode(actions.map((e) => e.toJson()).toList());
  }

  List<RuleAction> deserializeActions(String jsonStr) {
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => RuleAction.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [];
    }
  }

  String serializeFieldModifications(List<FieldModification> modifications) {
    return jsonEncode(modifications.map((e) => e.toJson()).toList());
  }

  List<FieldModification> deserializeFieldModifications(String jsonStr) {
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => FieldModification.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [];
    }
  }
}
