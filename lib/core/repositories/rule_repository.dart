import 'package:drift/drift.dart';
import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';
import '../../../features/rules/domain/entities/transaction_rule.dart';
import '../../../features/rules/domain/entities/rule_application.dart';
import '../../../features/rules/domain/services/rule_engine.dart';

/// Repository managing classification rules.
///
/// Ported from RuleRepositoryImpl.kt.
class RuleRepository {
  final RuleDao _ruleDao;
  final RuleApplicationDao _appDao;
  static const _engine = RuleEngine();

  const RuleRepository(this._ruleDao, this._appDao);

  Future<int> insertRule(TransactionRule rule) {
    final companion = RulesTableCompanion(
      id: Value(rule.id),
      name: Value(rule.name),
      description: Value(rule.description),
      priority: Value(rule.priority),
      conditions: Value(_engine.serializeConditions(rule.conditions)),
      actions: Value(_engine.serializeActions(rule.actions)),
      isActive: Value(rule.isActive),
      isSystemTemplate: Value(rule.isSystemTemplate),
      createdAt: Value(rule.createdAt),
      updatedAt: Value(rule.updatedAt),
    );
    return _ruleDao.insertRule(companion);
  }

  Future<List<TransactionRule>> getRules() async {
    final list = await _ruleDao.getAllRules();
    return list.map(_mapToDomain).toList();
  }

  Stream<List<TransactionRule>> watchRules() {
    return _ruleDao.watchAllRules().map((list) => list.map(_mapToDomain).toList());
  }

  Future<int> deleteRule(String id) => _ruleDao.deleteRule(id);

  Future<int> insertApplication(RuleApplication app) {
    final companion = RuleApplicationsTableCompanion(
      id: Value(app.id),
      ruleId: Value(app.ruleId),
      ruleName: Value(app.ruleName),
      transactionId: Value(app.transactionId),
      fieldsModified: Value(_engine.serializeFieldModifications(app.fieldsModified)),
      appliedAt: Value(app.appliedAt),
    );
    return _appDao.insertApplication(companion);
  }

  Future<List<RuleApplication>> getApplicationsForRule(String ruleId) async {
    final list = await _appDao.getApplicationsForRule(ruleId);
    return list.map(_mapAppToDomain).toList();
  }

  Future<int> deleteRuleApplicationsForTransaction(String transactionId) {
    return _appDao.deleteApplicationsForTransaction(transactionId);
  }

  Future<void> saveRuleApplications(List<RuleApplication> ruleApps) async {
    for (final app in ruleApps) {
      await insertApplication(app);
    }
  }

  Future<List<TransactionRule>> getActiveRulesByType(bool isIncome) async {
    final all = await getRules();
    return all.where((r) => r.isActive).toList();
  }

  TransactionRule _mapToDomain(RulesTableData row) {
    return TransactionRule(
      id: row.id,
      name: row.name,
      description: row.description,
      priority: row.priority,
      conditions: _engine.deserializeConditions(row.conditions),
      actions: _engine.deserializeActions(row.actions),
      isActive: row.isActive,
      isSystemTemplate: row.isSystemTemplate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  RuleApplication _mapAppToDomain(RuleApplicationsTableData row) {
    return RuleApplication(
      id: row.id,
      ruleId: row.ruleId,
      ruleName: row.ruleName,
      transactionId: row.transactionId,
      fieldsModified: _engine.deserializeFieldModifications(row.fieldsModified),
      appliedAt: row.appliedAt,
    );
  }
}
