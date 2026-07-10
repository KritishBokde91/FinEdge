# PennyWise → Finsight Migration Audit

This audit document tracks the status of porting code from the Android/Kotlin codebase (`pennywiseai-tracker/`) to the Flutter/Dart codebase (`finsight_ai/`).

## Summary of Findings

1. **Base Package Path**: `pennywiseai-tracker/app/src/main/java/com/pennywiseai/tracker/` (Confirmed)
2. **Appendix A Gaps**: The original Appendix A ONLY listed files in the `app` module. The entire `parser-core/` module (which houses all bank-specific parsers) and the `shared/` module (Kotlin Multiplatform common layer) were completely omitted. These are documented in sections below.
3. **Port Fidelity Issue**: `CompiledPatterns.kt` was flagged as Already Ported, but it is missing the `Cleaning` regexes and several HDFC mandate patterns. We have flagged this as **⚠️ Partially ported** to highlight that code needs to be added.

## 📱 Module: app (Appendix A)

### app/billing/

- [ ] billing/EntitlementGate.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/billing/domain/services/entitlement_gate.dart`
- [ ] billing/EntitlementSource.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/billing/domain/repositories/entitlement_source.dart`
- [ ] billing/FreeTierLimits.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/billing/domain/entities/free_tier_limits.dart`
- [ ] billing/ProProduct.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/billing/domain/entities/pro_product.dart`
- [ ] billing/PurchaseGateway.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] billing/PurchaseLauncher.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] billing/PurchaseResult.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/billing/domain/entities/purchase_result.dart`

### app/core/

- [ ] core/CompiledPatterns.kt — **⚠️ Partially ported**
  *Note:* Mapped to `lib/core/constants/compiled_patterns.dart` but is missing cleaning patterns and deduction date patterns from Kotlin.
- [ ] core/Constants.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/constants/time_constants.dart`
- [ ] core/TimeConstants.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/constants/time_constants.dart`

### app/data/backup/

- [ ] data/backup/BackupExporter.kt — **❌ Not ported at all**
  *Note:* Mapped to `lib/features/backup/domain/repositories/backup_exporter.dart` but it is a stub/empty
- [ ] data/backup/BackupImporter.kt — **❌ Not ported at all**
  *Note:* Mapped to `lib/features/backup/domain/repositories/backup_importer.dart` but it is a stub/empty
- [ ] data/backup/BackupModels.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/backup/domain/entities/backup_models.dart`
- [ ] data/backup/BackupSerializers.kt — **❌ Not ported at all**

### app/data/contacts/

- [ ] data/contacts/ContactsResolver.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/sms_intelligence/domain/services/contacts_resolver_service.dart`
- [ ] data/contacts/LocalMerchantDisplay.kt — **❌ Not ported at all**
- [ ] data/contacts/MerchantContactDisplay.kt — **❌ Not ported at all**

### app/data/currency/

- [ ] data/currency/CurrencyConversionService.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/currency/domain/services/currency_conversion_service.dart`
- [ ] data/currency/ExchangeRateProvider.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/currency/data/providers/exchange_rate_provider.dart`

### app/data/database/

- [ ] data/database/PennyWiseDatabase.kt — **❌ Not ported at all**

### app/data/database/converter/

- [ ] data/database/converter/Converters.kt — **❌ Not ported at all**

### app/data/database/dao/

- [ ] data/database/dao/AccountBalanceDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/BankNotificationDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/BudgetDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/BudgetSnapshotDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/CardDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/CategoryDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/ChatDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/ExchangeRateDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/LoanDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/MerchantMappingDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/ProfileDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/RuleApplicationDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/RuleDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/SubscriptionDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/TransactionDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/TransactionGroupDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/TransactionSplitDao.kt — **❌ Not ported at all**
- [ ] data/database/dao/UnrecognizedSmsDao.kt — **❌ Not ported at all**

### app/data/database/entity/

- [ ] data/database/entity/AccountBalanceEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/BankNotificationEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/BudgetCategoryEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/BudgetCategoryMonthSnapshotEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/BudgetEntity.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/budget_planner/domain/entities/budget_entity.dart`
- [ ] data/database/entity/BudgetMonthSnapshotEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/BudgetWithCategories.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/backup/domain/entities/budget_with_categories.dart`
- [ ] data/database/entity/CardEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/CategoryEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/ChatMessage.kt — **❌ Not ported at all**
- [ ] data/database/entity/ExchangeRateEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/LoanEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/MerchantMappingEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/ProfileEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/RuleApplicationEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/RuleEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/SubscriptionEntity.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/subscriptions/domain/entities/subscription_entity.dart`
- [ ] data/database/entity/TransactionEntity.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/transactions/domain/entities/transaction_entity.dart`
- [ ] data/database/entity/TransactionGroupEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/TransactionSplitEntity.kt — **❌ Not ported at all**
- [ ] data/database/entity/TransactionWithSplits.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/backup/domain/entities/transaction_with_splits.dart`
- [ ] data/database/entity/UnrecognizedSmsEntity.kt — **❌ Not ported at all**

### app/data/export/

- [ ] data/export/CsvExporter.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/backup/domain/services/csv_exporter_service.dart`

### app/data/manager/

- [ ] data/manager/SmsScanManager.kt — **❌ Not ported at all**
- [ ] data/manager/SmsTransactionProcessor.kt — **❌ Not ported at all**
- [ ] data/manager/TransactionDeduplication.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/sms_intelligence/domain/services/transaction_deduplication.dart`

### app/data/mapper/

- [ ] data/mapper/ParsedTransactionMapper.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/sms_intelligence/domain/services/parsed_transaction_mapper.dart`

### app/data/model/

- [ ] data/model/ChatContext.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/ai_assistant/domain/entities/chat_context.dart`

### app/data/preferences/

- [ ] data/preferences/AccentColor.kt — **❌ Not ported at all**
- [ ] data/preferences/AppFont.kt — **❌ Not ported at all**
- [ ] data/preferences/CoverStyle.kt — **❌ Not ported at all**
- [ ] data/preferences/NavBarStyle.kt — **❌ Not ported at all**
- [ ] data/preferences/NumberFormatStyle.kt — **❌ Not ported at all**
- [ ] data/preferences/ThemeStyle.kt — **❌ Not ported at all**
- [ ] data/preferences/UserPreferencesRepository.kt — **❌ Not ported at all**

### app/data/receipt/

- [ ] data/receipt/ReceiptManager.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/services/receipt_manager_service.dart`

### app/data/repository/

- [ ] data/repository/AccountBalanceRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/account_balance_repository.dart`
- [ ] data/repository/AiContextRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/ai_context_repository.dart`
- [ ] data/repository/AppLockRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/app_lock_repository.dart`
- [ ] data/repository/BankNotificationRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/bank_notification_repository.dart`
- [ ] data/repository/BudgetGroupModels.kt — **❌ Not ported at all**
- [ ] data/repository/BudgetGroupRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/budget_group_repository.dart`
- [ ] data/repository/BudgetRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/budget_planner/domain/repositories/budget_repository.dart`
- [ ] data/repository/CardRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/card_repository.dart`
- [ ] data/repository/CategoryRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/category_repository.dart`
- [ ] data/repository/LlmRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/llm_repository.dart`
- [ ] data/repository/LoanRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/loan_repository.dart`
- [ ] data/repository/MerchantMappingRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/merchant_mapping_repository.dart`
- [ ] data/repository/ModelRepository.kt — **❌ Not ported at all**
  *Note:* Mapped to `lib/core/repositories/model_repository.dart` but it is a stub/empty
- [ ] data/repository/ProfileRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/profile_repository.dart`
- [ ] data/repository/RuleRepositoryImpl.kt — **❌ Not ported at all**
- [ ] data/repository/SubscriptionRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/subscriptions/domain/repositories/subscription_repository.dart`
- [ ] data/repository/TransactionGroupRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/transaction_group_repository.dart`
- [ ] data/repository/TransactionRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/transactions/domain/repositories/transaction_repository.dart`
- [ ] data/repository/UnrecognizedSmsRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/unrecognized_sms_repository.dart`

### app/data/service/

- [ ] data/service/LlmServiceImpl.kt — **❌ Not ported at all**

### app/data/statement/

- [ ] data/statement/GPayPdfParser.kt — **❌ Not ported at all**
- [ ] data/statement/ImportStatementUseCase.kt — **❌ Not ported at all**
- [ ] data/statement/PdfParserFactory.kt — **❌ Not ported at all**
- [ ] data/statement/PdfStatementParser.kt — **❌ Not ported at all**
- [ ] data/statement/PdfTextExtractor.kt — **❌ Not ported at all**
- [ ] data/statement/PhonePePdfParser.kt — **❌ Not ported at all**
- [ ] data/statement/StatementImportProcessor.kt — **❌ Not ported at all**
- [ ] data/statement/StatementImportResult.kt — **❌ Not ported at all**
- [ ] data/statement/StatementTransactionEnricher.kt — **❌ Not ported at all**

### app/di/

- [ ] di/ApplicationModule.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] di/DatabaseModule.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] di/LlmModule.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] di/RuleModule.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/domain/model/

- [ ] domain/model/AccountTypeExtensions.kt — **❌ Not ported at all**
- [ ] domain/model/rule/RuleAction.kt — **❌ Not ported at all**
- [ ] domain/model/rule/RuleApplication.kt — **❌ Not ported at all**
- [ ] domain/model/rule/RuleCondition.kt — **❌ Not ported at all**
- [ ] domain/model/rule/TransactionRule.kt — **❌ Not ported at all**

### app/domain/repository/

- [ ] domain/repository/RuleRepository.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/repositories/rule_repository.dart`

### app/domain/security/

- [ ] domain/security/BiometricAuthManager.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/domain/service/

- [ ] domain/service/LlmService.kt — **❌ Not ported at all**
- [ ] domain/service/RuleEngine.kt — **❌ Not ported at all**
- [ ] domain/service/RuleTemplateService.kt — **❌ Not ported at all**

### app/domain/usecase/

- [ ] domain/usecase/AddSubscriptionUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/AddTransactionUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ApplyRulesToPastTransactionsUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/GenerateIncomeAutopayUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/GetCategoriesUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/InitializeRuleTemplatesUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/MarkSubscriptionPaidUseCase.kt — **❌ Not ported at all**

### app/initializer/

- [ ] initializer/WorkManagerInitializer.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/navigation/

- [ ] navigation/PennyWiseDestinations.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] navigation/PennyWiseNavHost.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/presentation/

- [ ] presentation/accounts/AccountDetailScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/AccountDetailViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/AddAccountScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/BalanceHistoryScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/BalanceHistoryViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/ManageAccountsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/ManageAccountsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/accounts/MergeAccountsSheet.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/add/AddScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/add/AddViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/add/SubscriptionTabContent.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/add/TransactionTabContent.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/budgetgroups/BudgetGroupEditScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/budgetgroups/BudgetGroupEditViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/budgetgroups/BudgetGroupsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/budgetgroups/BudgetGroupsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/categories/CategoriesScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/categories/CategoriesViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/categories/CategoryEditDialog.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/common/CurrencyGroupedTotals.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/common/Filters.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/exchangerates/ExchangeRatesScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/exchangerates/ExchangeRatesViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/groups/TransactionGroupDetailScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/groups/TransactionGroupDetailViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/groups/TransactionGroupsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/groups/TransactionGroupsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/home/HomeRecentItem.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/home/HomeScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/home/HomeViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/loans/LoanDetailScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/loans/LoanDetailViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/loans/LoansScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/loans/LoansViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/navigation/BottomNavItem.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/paywall/UpgradeSheet.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/paywall/UpgradeUiState.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/paywall/UpgradeViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/statement/ImportStatementScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/statement/ImportStatementViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/subscriptions/MarkAsPaidSheet.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/subscriptions/SubscriptionsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/subscriptions/SubscriptionsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/ExportTransactionsDialog.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/ExportViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/TransactionDetailScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/TransactionDetailViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/TransactionTotalsCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/TransactionsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] presentation/transactions/TransactionsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/receiver/

- [ ] receiver/BankNotificationConfig.kt — **❌ Not ported at all**
- [ ] receiver/BankNotificationListenerService.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] receiver/NotificationActionReceiver.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] receiver/QuickCategoryPickerActivity.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] receiver/SmsBroadcastReceiver.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/root/

- [ ] MainActivity.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] PennyWiseApp.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] PennyWiseApplication.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/ui/

- [ ] ui/LocalSharedTransitionScope.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/MainScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/SharedTransitionUtils.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/animations/ChevronRotation.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/AnimatedCurrencyText.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/AvatarHelper.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/BalanceChart.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/BrandIcon.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CategoryBreakdownCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CategoryChip.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CollapsibleFilterRow.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CoverStyleRenderer.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CustomDateRangePicker.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/CustomTitleTopAppBar.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/DashedLine.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/ErrorState.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/ExpandableList.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/ExpressiveFilterChip.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/FinancialAccountRow.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/GreetingCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/HeatmapMonthLabels.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/PennyWiseBottomNavigation.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/PennyWiseCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/PennyWiseEmptyState.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/PennyWiseScaffold.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/PreferenceSwitch.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/ProfileFilterDropdown.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/QuickCategoryPickerSheet.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/ShimmerEffect.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/SmsParsingProgressDialog.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/SplitEditor.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/SpotlightTutorial.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/TransactionTypeFilterUi.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/UnifiedAccountsCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/WhatsNew.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/AccountCarousel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/BalanceCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/BalanceSparkline.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/BudgetCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/BudgetCarousel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/CashFlowCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/ExpandableCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/GradientMeshCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/GroupCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/HeatmapWidget.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/ListItemCardV2.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/PennyWiseCardV2.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/SectionHeaderV2.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/SummaryCardV2.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/cards/TransactionItem.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/skeleton/BalanceCardSkeleton.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/components/skeleton/TransactionItemSkeleton.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/effects/BlurEffects.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/effects/BlurredAnimatedVisibility.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/effects/BottomFade.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/effects/Overscroll.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/icons/BrandIcons.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/icons/CategoryMapping.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/AppLockScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/PermissionScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/AnalyticsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/AnalyticsSummaryCard.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/AnalyticsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/CategoryPieChart.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/SpendingBarChart.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/analytics/SpendingHeatmap.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/chat/ChatScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/chat/ChatViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/onboarding/OnBoardingScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/onboarding/OnBoardingViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/rules/CreateRuleScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/rules/RulesScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/settings/AppearanceScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/settings/FAQScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/settings/SettingsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/settings/SettingsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/unrecognized/UnrecognizedSmsScreen.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/screens/unrecognized/UnrecognizedSmsViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Color.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Dimensions.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Shape.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Spacing.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Theme.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/theme/Type.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/AppLockViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/MainViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/PermissionViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/RulesViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/SpotlightViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] ui/viewmodel/ThemeViewModel.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/utils/

- [ ] utils/CurrencyFormatter.kt — **❌ Not ported at all**
- [ ] utils/CurrencyUtils.kt — **❌ Not ported at all**
- [ ] utils/DateRangeUtils.kt — **❌ Not ported at all**
- [ ] utils/DeviceEncryption.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] utils/EntityExtensions.kt — **❌ Not ported at all**
- [ ] utils/Money.kt — **❌ Not ported at all**
- [ ] utils/MoneyTotals.kt — **❌ Not ported at all**
- [ ] utils/SmsReportUrlBuilder.kt — **❌ Not ported at all**
- [ ] utils/TokenUtils.kt — **❌ Not ported at all**

### app/widget/

- [ ] widget/AddTransactionWidget.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/AddTransactionWidgetReceiver.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/BudgetWidget.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/BudgetWidgetData.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/BudgetWidgetDataStore.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/BudgetWidgetReceiver.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/BudgetWidgetUpdateWorker.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/PennyWiseWidgetTheme.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/RecentTransactionsWidget.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/RecentTransactionsWidgetData.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/RecentTransactionsWidgetDataStore.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/RecentTransactionsWidgetReceiver.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] widget/RecentTransactionsWidgetUpdateWorker.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.

### app/worker/

- [ ] worker/BankNotificationRetryWorker.kt — **🚫 N/A**
  *Note:* Android-framework or Compose UI file; not part of engine port.
- [ ] worker/OptimizedSmsReaderWorker.kt — **❌ Not ported at all**

## ⚙️ Module: parser-core (Missing from Appendix A entirely)
> [!IMPORTANT]
> This module contains the core bank-specific parsers. In the original App, they are compiled as a separate library and are crucial for the transaction recognition pipeline.

### parser-core/bank/

- [ ] bank/ADCBParser.kt — **❌ Not ported at all**
- [ ] bank/AMEXBankParser.kt — **❌ Not ported at all**
- [ ] bank/AUBankParser.kt — **❌ Not ported at all**
- [ ] bank/AccessBankParser.kt — **❌ Not ported at all**
- [ ] bank/AdelFiParser.kt — **❌ Not ported at all**
- [ ] bank/AirtelPaymentsBankParser.kt — **❌ Not ported at all**
- [ ] bank/AlRajhiBankParser.kt — **❌ Not ported at all**
- [ ] bank/AlecuBankParser.kt — **❌ Not ported at all**
- [ ] bank/AlinmaBankParser.kt — **❌ Not ported at all**
- [ ] bank/AltanaFCUParser.kt — **❌ Not ported at all**
- [ ] bank/ArabBankParser.kt — **❌ Not ported at all**
- [ ] bank/AxisBankParser.kt — **❌ Not ported at all**
- [ ] bank/BAACBankParser.kt — **❌ Not ported at all**
- [ ] bank/BPCEParser.kt — **❌ Not ported at all**
- [ ] bank/BancolombiaParser.kt — **❌ Not ported at all**
- [ ] bank/BandhanBankParser.kt — **❌ Not ported at all**
- [ ] bank/BangkokBankParser.kt — **❌ Not ported at all**
- [ ] bank/BankMuscatParser.kt — **❌ Not ported at all**
- [ ] bank/BankOfBarodaParser.kt — **❌ Not ported at all**
- [ ] bank/BankOfIndiaParser.kt — **❌ Not ported at all**
- [ ] bank/BankParser.kt — **❌ Not ported at all**
- [ ] bank/BankParserFactory.kt — **❌ Not ported at all**
- [ ] bank/BankParserRegistry.kt — **❌ Not ported at all**
- [ ] bank/BankinoBankParser.kt — **❌ Not ported at all**
- [ ] bank/BaseIndianBankParser.kt — **❌ Not ported at all**
- [ ] bank/BaseIranianBankParser.kt — **❌ Not ported at all**
- [ ] bank/BaseThailandBankParser.kt — **❌ Not ported at all**
- [ ] bank/BkashParser.kt — **❌ Not ported at all**
- [ ] bank/BluBankParser.kt — **❌ Not ported at all**
- [ ] bank/CBEBankParser.kt — **❌ Not ported at all**
- [ ] bank/CIBEgyptParser.kt — **❌ Not ported at all**
- [ ] bank/CIMBThaiParser.kt — **❌ Not ported at all**
- [ ] bank/CanaraBankParser.kt — **❌ Not ported at all**
- [ ] bank/CashfreeParser.kt — **❌ Not ported at all**
- [ ] bank/CentralBankOfIndiaParser.kt — **❌ Not ported at all**
- [ ] bank/CharlesSchwabParser.kt — **❌ Not ported at all**
- [ ] bank/ChaseBankParser.kt — **❌ Not ported at all**
- [ ] bank/CitiBankParser.kt — **❌ Not ported at all**
- [ ] bank/CitizensBankParser.kt — **❌ Not ported at all**
- [ ] bank/CityUnionBankParser.kt — **❌ Not ported at all**
- [ ] bank/CrdbBankParser.kt — **❌ Not ported at all**
- [ ] bank/CredParser.kt — **❌ Not ported at all**
- [ ] bank/DBSBankParser.kt — **❌ Not ported at all**
- [ ] bank/DOPBankParser.kt — **❌ Not ported at all**
- [ ] bank/DashenBankParser.kt — **❌ Not ported at all**
- [ ] bank/DhanlaxmiBankParser.kt — **❌ Not ported at all**
- [ ] bank/DiamondTrustBankParser.kt — **❌ Not ported at all**
- [ ] bank/DiscoverCardParser.kt — **❌ Not ported at all**
- [ ] bank/EMolaParser.kt — **❌ Not ported at all**
- [ ] bank/EmiratesIslamicParser.kt — **❌ Not ported at all**
- [ ] bank/EmiratesNBDParser.kt — **❌ Not ported at all**
- [ ] bank/EnparaBankParser.kt — **❌ Not ported at all**
- [ ] bank/EquitasBankParser.kt — **❌ Not ported at all**
- [ ] bank/EverestBankParser.kt — **❌ Not ported at all**
- [ ] bank/FABParser.kt — **❌ Not ported at all**
- [ ] bank/FaysalBankParser.kt — **❌ Not ported at all**
- [ ] bank/FederalBankParser.kt — **❌ Not ported at all**
- [ ] bank/GSBBankParser.kt — **❌ Not ported at all**
- [ ] bank/GreaterBankParser.kt — **❌ Not ported at all**
- [ ] bank/HDFCBankParser.kt — **❌ Not ported at all**
- [ ] bank/HDFCMutualFundParser.kt — **❌ Not ported at all**
- [ ] bank/HSBCBankParser.kt — **❌ Not ported at all**
- [ ] bank/HuntingtonBankParser.kt — **❌ Not ported at all**
- [ ] bank/ICICIBankParser.kt — **❌ Not ported at all**
- [ ] bank/IDBIBankParser.kt — **❌ Not ported at all**
- [ ] bank/IDFCFirstBankParser.kt — **❌ Not ported at all**
- [ ] bank/IPPBParser.kt — **❌ Not ported at all**
- [ ] bank/IndianBankParser.kt — **❌ Not ported at all**
- [ ] bank/IndianOverseasBankParser.kt — **❌ Not ported at all**
- [ ] bank/IndusIndBankParser.kt — **❌ Not ported at all**
- [ ] bank/JKBankParser.kt — **❌ Not ported at all**
- [ ] bank/JaizBankParser.kt — **❌ Not ported at all**
- [ ] bank/JanaSmallFinanceBankParser.kt — **❌ Not ported at all**
- [ ] bank/JioPayParser.kt — **❌ Not ported at all**
- [ ] bank/JioPaymentsBankParser.kt — **❌ Not ported at all**
- [ ] bank/JupiterBankParser.kt — **❌ Not ported at all**
- [ ] bank/JuspayParser.kt — **❌ Not ported at all**
- [ ] bank/KTCCreditCardParser.kt — **❌ Not ported at all**
- [ ] bank/KarnatakaBankParser.kt — **❌ Not ported at all**
- [ ] bank/KasikornBankParser.kt — **❌ Not ported at all**
- [ ] bank/KeralaBankParser.kt — **❌ Not ported at all**
- [ ] bank/KeralaGraminBankParser.kt — **❌ Not ported at all**
- [ ] bank/KeystoneBankParser.kt — **❌ Not ported at all**
- [ ] bank/KotakBankParser.kt — **❌ Not ported at all**
- [ ] bank/KrungThaiBankParser.kt — **❌ Not ported at all**
- [ ] bank/KrungsriBankParser.kt — **❌ Not ported at all**
- [ ] bank/LaxmiBankParser.kt — **❌ Not ported at all**
- [ ] bank/LazyPayParser.kt — **❌ Not ported at all**
- [ ] bank/LivBankParser.kt — **❌ Not ported at all**
- [ ] bank/LumbiniBikashBankParser.kt — **❌ Not ported at all**
- [ ] bank/MBankCZParser.kt — **❌ Not ported at all**
- [ ] bank/MPESAParser.kt — **❌ Not ported at all**
- [ ] bank/MPesaMozambiqueParser.kt — **❌ Not ported at all**
- [ ] bank/MPesaTanzaniaParser.kt — **❌ Not ported at all**
- [ ] bank/MachchhapuchreBankParser.kt — **❌ Not ported at all**
- [ ] bank/ManjushreeFinanceParser.kt — **❌ Not ported at all**
- [ ] bank/MashreqBankParser.kt — **❌ Not ported at all**
- [ ] bank/MellatBankParser.kt — **❌ Not ported at all**
- [ ] bank/MelliBankParser.kt — **❌ Not ported at all**
- [ ] bank/MillenniumBimParser.kt — **❌ Not ported at all**
- [ ] bank/MixxByYasParser.kt — **❌ Not ported at all**
- [ ] bank/NMBBankParser.kt — **❌ Not ported at all**
- [ ] bank/NMBTanzaniaParser.kt — **❌ Not ported at all**
- [ ] bank/NSDLPaymentsBankParser.kt — **❌ Not ported at all**
- [ ] bank/NabilBankParser.kt — **❌ Not ported at all**
- [ ] bank/NationalSavingsBankParser.kt — **❌ Not ported at all**
- [ ] bank/NationsTrustBankParser.kt — **❌ Not ported at all**
- [ ] bank/NaviMutualFundParser.kt — **❌ Not ported at all**
- [ ] bank/NavyFederalParser.kt — **❌ Not ported at all**
- [ ] bank/NepalBankParser.kt — **❌ Not ported at all**
- [ ] bank/NepalSBIBankParser.kt — **❌ Not ported at all**
- [ ] bank/OldHickoryParser.kt — **❌ Not ported at all**
- [ ] bank/OneCardParser.kt — **❌ Not ported at all**
- [ ] bank/OpayBankParser.kt — **❌ Not ported at all**
- [ ] bank/PNBBankParser.kt — **❌ Not ported at all**
- [ ] bank/ParsianBankParser.kt — **❌ Not ported at all**
- [ ] bank/PrimeCommercialBankParser.kt — **❌ Not ported at all**
- [ ] bank/PriorbankParser.kt — **❌ Not ported at all**
- [ ] bank/PunjabSindBankParser.kt — **❌ Not ported at all**
- [ ] bank/SBIBankParser.kt — **❌ Not ported at all**
- [ ] bank/SNBAlAhliBankParser.kt — **❌ Not ported at all**
- [ ] bank/STCBankParser.kt — **❌ Not ported at all**
- [ ] bank/SabbBankParser.kt — **❌ Not ported at all**
- [ ] bank/SampathBankParser.kt — **❌ Not ported at all**
- [ ] bank/SaraswatBankParser.kt — **❌ Not ported at all**
- [ ] bank/SelcomPesaParser.kt — **❌ Not ported at all**
- [ ] bank/SiamCommercialBankParser.kt — **❌ Not ported at all**
- [ ] bank/SiddharthaBankParser.kt — **❌ Not ported at all**
- [ ] bank/SliceParser.kt — **❌ Not ported at all**
- [ ] bank/SouthIndianBankParser.kt — **❌ Not ported at all**
- [ ] bank/SparkasseRheinMaasParser.kt — **❌ Not ported at all**
- [ ] bank/StandardBankMozambiqueParser.kt — **❌ Not ported at all**
- [ ] bank/StandardCharteredBankParser.kt — **❌ Not ported at all**
- [ ] bank/StandardCharteredNepalParser.kt — **❌ Not ported at all**
- [ ] bank/TBankParser.kt — **❌ Not ported at all**
- [ ] bank/TTBBankParser.kt — **❌ Not ported at all**
- [ ] bank/TelebirrParser.kt — **❌ Not ported at all**
- [ ] bank/TigoPesaParser.kt — **❌ Not ported at all**
- [ ] bank/UAEBankParser.kt — **❌ Not ported at all**
- [ ] bank/UCOBankParser.kt — **❌ Not ported at all**
- [ ] bank/UOBThailandParser.kt — **❌ Not ported at all**
- [ ] bank/UnionBankParser.kt — **❌ Not ported at all**
- [ ] bank/UtkarshBankParser.kt — **❌ Not ported at all**
- [ ] bank/YesBankParser.kt — **❌ Not ported at all**
- [ ] bank/ZemenBankParser.kt — **❌ Not ported at all**
- [ ] bank/ZenithBankParser.kt — **❌ Not ported at all**

### parser-core/root/

- [ ] CompiledPatterns.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/constants/compiled_patterns.dart`
- [ ] Constants.kt — **✅ Already ported**
  *Note:* Mapped to `lib/core/constants/time_constants.dart`
- [ ] MandateInfo.kt — **❌ Not ported at all**
- [ ] ParsedTransaction.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/sms_intelligence/domain/services/parsed_transaction_mapper.dart`
- [ ] TransactionType.kt — **❌ Not ported at all**

## 🔗 Module: shared (Missing from Appendix A entirely)
> [!NOTE]
> Contains Kotlin Multiplatform shared entities, repositories, and use cases.

### shared/core/

- [ ] core/SharedTimeConstants.kt — **❌ Not ported at all**

### shared/data/

- [ ] data/SharedDataGraph.kt — **❌ Not ported at all**

### shared/data/bootstrap/

- [ ] data/bootstrap/DefaultCategoryData.kt — **❌ Not ported at all**
- [ ] data/bootstrap/DefaultSharedCategories.kt — **❌ Not ported at all**
- [ ] data/bootstrap/SharedDataInitializer.kt — **❌ Not ported at all**

### shared/data/local/

- [ ] data/local/SharedDatabase.kt — **❌ Not ported at all**
- [ ] data/local/SharedDatabaseFactory.kt — **❌ Not ported at all**

### shared/data/local/dao/

- [ ] data/local/dao/SharedAccountBalanceDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedBudgetDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedCardDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedCategoryBudgetLimitDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedCategoryDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedExchangeRateDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedMerchantMappingDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedRuleApplicationDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedRuleDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedSubscriptionDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedTransactionDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedTransactionSplitDao.kt — **❌ Not ported at all**
- [ ] data/local/dao/SharedUnrecognizedSmsDao.kt — **❌ Not ported at all**

### shared/data/local/entity/

- [ ] data/local/entity/SharedAccountBalanceEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedBudgetCategoryEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedBudgetEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedCardEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedCategoryBudgetLimitEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedCategoryEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedExchangeRateEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedMerchantMappingEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedRuleApplicationEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedRuleEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedSubscriptionEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedTransactionEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedTransactionSplitEntity.kt — **❌ Not ported at all**
- [ ] data/local/entity/SharedUnrecognizedSmsEntity.kt — **❌ Not ported at all**

### shared/data/model/

- [ ] data/model/SharedCategory.kt — **❌ Not ported at all**
- [ ] data/model/SharedTransaction.kt — **❌ Not ported at all**
- [ ] data/model/SharedTransactionType.kt — **❌ Not ported at all**

### shared/data/repository/

- [ ] data/repository/RoomSharedAccountRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedBudgetRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedCategoryRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedExchangeRateRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedMerchantMappingRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedRuleRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedSplitRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedSubscriptionRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedTransactionRepository.kt — **❌ Not ported at all**
- [ ] data/repository/RoomSharedUnrecognizedSmsRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedAccountRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedBudgetRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedCategoryRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedExchangeRateRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedMerchantMappingRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedRuleRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedSplitRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedSubscriptionRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedTransactionRepository.kt — **❌ Not ported at all**
- [ ] data/repository/SharedUnrecognizedSmsRepository.kt — **❌ Not ported at all**

### shared/data/repository/mapper/

- [ ] data/repository/mapper/SharedDataMappers.kt — **❌ Not ported at all**

### shared/data/statement/

- [ ] data/statement/GPaySharedStatementParser.kt — **❌ Not ported at all**
- [ ] data/statement/PhonePeSharedStatementParser.kt — **❌ Not ported at all**
- [ ] data/statement/SharedParsedStatementTransaction.kt — **❌ Not ported at all**
- [ ] data/statement/SharedParserUtils.kt — **❌ Not ported at all**
- [ ] data/statement/SharedPdfTextExtractor.kt — **❌ Not ported at all**
- [ ] data/statement/SharedStatementImportResult.kt — **❌ Not ported at all**
- [ ] data/statement/SharedStatementParser.kt — **❌ Not ported at all**
- [ ] data/statement/SharedStatementParserFactory.kt — **❌ Not ported at all**

### shared/data/util/

- [ ] data/util/TimeProvider.kt — **❌ Not ported at all**

### shared/domain/mapping/

- [ ] domain/mapping/SharedCategoryMapping.kt — **❌ Not ported at all**

### shared/domain/usecase/

- [ ] domain/usecase/CreateManualTransactionUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ImportStatementUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageAccountUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageBudgetUseCase.kt — **✅ Already ported**
  *Note:* Mapped to `lib/features/budget_planner/domain/usecases/manage_budget_usecase.dart`
- [ ] domain/usecase/ManageExchangeRateUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageMerchantMappingUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageRulesUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageSplitUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageSubscriptionUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/ManageUnrecognizedSmsUseCase.kt — **❌ Not ported at all**
- [ ] domain/usecase/TransactionMutationModels.kt — **❌ Not ported at all**
- [ ] domain/usecase/UpdateManualTransactionUseCase.kt — **❌ Not ported at all**

### shared/root/

- [ ] Greeting.kt — **❌ Not ported at all**
- [ ] PennyWiseSharedFacade.kt — **❌ Not ported at all**

## Porting Statistics

- **Total Audited Files**: 533
- **✅ Already Ported**: 42
- **⚠️ Partially Ported**: 1
- **❌ Not Ported At All**: 318
- **🚫 N/A (Deferred UI/Platform)**: 172
- **💳 OPT (Optional features)**: 0
- **⚠️ Missing in Source**: 0
