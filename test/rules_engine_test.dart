import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/rules/domain/entities/transaction_rule.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_condition.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_action.dart';
import 'package:finsight_ai/features/rules/domain/services/rule_engine.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  const engine = RuleEngine();

  group('RuleEngine - Matching and Execution', () {
    test('matches and executes category override rule on merchant name', () {
      final rule = TransactionRule(
        id: 'r1',
        name: 'Coffee Rule',
        priority: 100,
        conditions: const [
          RuleCondition(
            field: TransactionField.merchant,
            operator: ConditionOperator.contains,
            value: 'starbucks',
          ),
        ],
        actions: const [
          RuleAction(
            field: TransactionField.category,
            actionType: ActionType.set,
            value: 'Food & Beverage',
          ),
        ],
      );

      final transaction = TransactionEntity(
        id: 'tx_1',
        smsId: 'sms_1',
        amount: 350.0,
        merchant: 'Starbucks Coffee Bangalore',
        category: 'Shopping',
        timestamp: DateTime(2026, 3, 15, 14, 30),
        isIncome: false,
        accountSource: 'HDFC Bank',
        currency: 'INR',
      );

      final (modifiedTx, applications) = engine.evaluateRules(
        transaction,
        'Rs. 350 spent on card 1234 at Starbucks Coffee Bangalore',
        [rule],
      );

      expect(applications.length, equals(1));
      expect(applications.first.ruleName, equals('Coffee Rule'));
      expect(modifiedTx.category, equals('Food & Beverage'));
    });

    test('ignores non-matching rules', () {
      final rule = TransactionRule(
        id: 'r_uber',
        name: 'Uber Rule',
        priority: 50,
        conditions: const [
          RuleCondition(
            field: TransactionField.merchant,
            operator: ConditionOperator.contains,
            value: 'uber',
          ),
        ],
        actions: const [
          RuleAction(
            field: TransactionField.category,
            actionType: ActionType.set,
            value: 'Transport',
          ),
        ],
      );

      final transaction = TransactionEntity(
        id: 'tx_2',
        smsId: 'sms_2',
        amount: 150.0,
        merchant: 'Swiggy',
        category: 'Food',
        timestamp: DateTime(2026, 3, 15, 14, 30),
        isIncome: false,
        accountSource: 'ICICI Bank',
        currency: 'INR',
      );

      final (modifiedTx, applications) = engine.evaluateRules(
        transaction,
        'Swiggy order debited',
        [rule],
      );

      expect(applications.isEmpty, isTrue);
      expect(modifiedTx.category, equals('Food'));
    });
  });

  group('Rule serialization and deserialization', () {
    test('roundtrips conditions and actions cleanly', () {
      const conditions = [
        RuleCondition(
          field: TransactionField.amount,
          operator: ConditionOperator.greaterThan,
          value: '1000',
        ),
      ];
      const actions = [
        RuleAction(
          field: TransactionField.category,
          actionType: ActionType.set,
          value: 'High Value',
        ),
      ];

      final serializedCond = engine.serializeConditions(conditions);
      final deserializedCond = engine.deserializeConditions(serializedCond);
      expect(deserializedCond.length, equals(1));
      expect(deserializedCond.first.field, equals(TransactionField.amount));
      expect(deserializedCond.first.operator, equals(ConditionOperator.greaterThan));
      expect(deserializedCond.first.value, equals('1000'));

      final serializedAct = engine.serializeActions(actions);
      final deserializedAct = engine.deserializeActions(serializedAct);
      expect(deserializedAct.length, equals(1));
      expect(deserializedAct.first.actionType, equals(ActionType.set));
      expect(deserializedAct.first.value, equals('High Value'));
    });
  });
}
