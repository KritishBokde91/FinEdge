import 'package:flutter_test/flutter_test.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_condition.dart';
import 'package:finsight_ai/features/rules/domain/entities/rule_action.dart';
import 'package:finsight_ai/features/rules/domain/entities/transaction_rule.dart';
import 'package:finsight_ai/features/rules/domain/services/rule_engine.dart';
import 'package:finsight_ai/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  const ruleEngine = RuleEngine();

  group('RuleCondition validation', () {
    test('Should validate AMOUNT conditions correctly', () {
      const valid = RuleCondition(
        field: TransactionField.amount,
        operator: ConditionOperator.greaterThan,
        value: '150.00',
      );
      expect(valid.validate(), isTrue);

      const invalid = RuleCondition(
        field: TransactionField.amount,
        operator: ConditionOperator.lessThan,
        value: 'invalid_number',
      );
      expect(invalid.validate(), isFalse);
    });

    test('Should validate transaction hour and time correctly', () {
      const validHour = RuleCondition(
        field: TransactionField.transactionHour,
        operator: ConditionOperator.equals,
        value: '14',
      );
      expect(validHour.validate(), isTrue);

      const invalidHour = RuleCondition(
        field: TransactionField.transactionHour,
        operator: ConditionOperator.equals,
        value: '25',
      );
      expect(invalidHour.validate(), isFalse);

      const validTime = RuleCondition(
        field: TransactionField.transactionTime,
        operator: ConditionOperator.equals,
        value: '12:30',
      );
      expect(validTime.validate(), isTrue);
    });
  });

  group('RuleEngine precedence evaluation', () {
    // We construct the rule conditions representing:
    // (merchant == 'Amazon' AND amount > 100) OR merchant == 'Netflix'
    final conditions = [
      const RuleCondition(
        field: TransactionField.merchant,
        operator: ConditionOperator.equals,
        value: 'Amazon',
      ),
      const RuleCondition(
        field: TransactionField.amount,
        operator: ConditionOperator.greaterThan,
        value: '100',
        logicalOperator: LogicalOperator.and,
      ),
      const RuleCondition(
        field: TransactionField.merchant,
        operator: ConditionOperator.equals,
        value: 'Netflix',
        logicalOperator: LogicalOperator.or,
      ),
    ];

    test('Case 1: Should match when merchant is Amazon and amount is > 100', () {
      final tx = TransactionEntity(
        id: '1',
        smsId: 'sms-1',
        amount: 150.0,
        merchant: 'Amazon',
        category: 'Shopping',
        timestamp: DateTime.now(),
        isIncome: false,
        accountSource: 'HDFC',
      );

      final matched = ruleEngine.evaluateConditions(tx, null, conditions);
      expect(matched, isTrue);
    });

    test('Case 2: Should not match when merchant is Amazon but amount is <= 100', () {
      final tx = TransactionEntity(
        id: '2',
        smsId: 'sms-2',
        amount: 50.0,
        merchant: 'Amazon',
        category: 'Shopping',
        timestamp: DateTime.now(),
        isIncome: false,
        accountSource: 'HDFC',
      );

      final matched = ruleEngine.evaluateConditions(tx, null, conditions);
      expect(matched, isFalse);
    });

    test('Case 3: Should match when merchant is Netflix regardless of amount', () {
      final tx = TransactionEntity(
        id: '3',
        smsId: 'sms-3',
        amount: 20.0,
        merchant: 'Netflix',
        category: 'Other',
        timestamp: DateTime.now(),
        isIncome: false,
        accountSource: 'Kotak',
      );

      final matched = ruleEngine.evaluateConditions(tx, null, conditions);
      expect(matched, isTrue);
    });
  });

  group('Rule modifications and actions', () {
    test('Should apply set and prepend actions correctly', () {
      final rule = TransactionRule(
        name: 'Categorize and Prefix Netflix',
        conditions: [
          const RuleCondition(
            field: TransactionField.merchant,
            operator: ConditionOperator.contains,
            value: 'Netflix',
          ),
        ],
        actions: [
          const RuleAction(
            field: TransactionField.category,
            actionType: ActionType.set,
            value: 'Entertainment',
          ),
          const RuleAction(
            field: TransactionField.merchant,
            actionType: ActionType.prepend,
            value: 'Sub: ',
          ),
        ],
      );

      final tx = TransactionEntity(
        id: 'tx-10',
        smsId: 'sms-10',
        amount: 199.0,
        merchant: 'Netflix India',
        category: 'Other',
        timestamp: DateTime.now(),
        isIncome: false,
        accountSource: 'Kotak',
      );

      final (modifiedTx, applications) = ruleEngine.evaluateRules(tx, null, [rule]);

      expect(modifiedTx.category, equals('Entertainment'));
      expect(modifiedTx.merchant, equals('Sub: Netflix India'));
      expect(applications.length, equals(1));
      expect(applications.first.fieldsModified.length, equals(2));
      expect(applications.first.fieldsModified[0].newValue, equals('Entertainment'));
      expect(applications.first.fieldsModified[1].newValue, equals('Sub: Netflix India'));
    });
  });

  group('Rule blocking', () {
    test('Should identify transaction blocking rules', () {
      final blockRule = TransactionRule(
        name: 'Block promotional alerts',
        conditions: [
          const RuleCondition(
            field: TransactionField.merchant,
            operator: ConditionOperator.contains,
            value: 'Promo',
          ),
        ],
        actions: [
          const RuleAction(
            field: TransactionField.merchant,
            actionType: ActionType.block,
            value: '',
          ),
        ],
      );

      final tx = TransactionEntity(
        id: 'tx-20',
        smsId: 'sms-20',
        amount: 0.0,
        merchant: 'Kotak Promo Alert',
        category: 'Other',
        timestamp: DateTime.now(),
        isIncome: false,
        accountSource: 'Kotak',
      );

      final matchedRule = ruleEngine.shouldBlockTransaction(tx, null, [blockRule]);
      expect(matchedRule, isNotNull);
      expect(matchedRule!.name, equals('Block promotional alerts'));
    });
  });
}
