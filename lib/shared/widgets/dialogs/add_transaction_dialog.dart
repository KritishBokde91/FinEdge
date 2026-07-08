import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/di/use_case_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../features/transactions/domain/usecases/add_manual_transaction_usecase.dart';

/// Available categories for manual transactions — matches SmsParser categories.
const List<String> kTransactionCategories = [
  'Food',
  'Shopping',
  'Transport',
  'Entertainment',
  'Bills',
  'Investment',
  'Salary',
  'Recharge',
  'Transfer',
  'Cash',
  'Other',
];

/// A full-featured bottom sheet for adding manual transactions.
///
/// Ported from PennyWise's manual transaction flow which uses
/// [CreateManualTransactionUseCase] internally. This dialog:
///   - Takes amount, merchant name, category, income/expense toggle, date
///   - Calls [AddManualTransactionUseCase.execute] with validation
///   - Shows validation errors inline
///   - Pops with true on success so the caller can react
class AddTransactionDialog extends ConsumerStatefulWidget {
  const AddTransactionDialog({super.key});

  /// Convenience method to show this dialog as a modal bottom sheet.
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTransactionDialog(),
    );
    return result == true;
  }

  @override
  ConsumerState<AddTransactionDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _accountController = TextEditingController();

  bool _isIncome = false;
  String _selectedCategory = 'Other';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ──
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: AppRadius.borderCircular,
                ),
              ),
            ),
            AppSpacing.h16,

            // ── Title ──
            Text(
              'Add Transaction',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.h4,
            Text(
              'Manually record a financial transaction',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
            ),
            AppSpacing.h24,

            // ── Income / Expense Toggle ──
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Expense',
                    icon: Icons.arrow_upward_rounded,
                    isSelected: !_isIncome,
                    selectedColor: AppColors.error,
                    onTap: () => setState(() => _isIncome = false),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _TypeButton(
                    label: 'Income',
                    icon: Icons.arrow_downward_rounded,
                    isSelected: _isIncome,
                    selectedColor: AppColors.success,
                    onTap: () => setState(() => _isIncome = true),
                  ),
                ),
              ],
            ),
            AppSpacing.h16,

            // ── Amount Field ──
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount *',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                prefixText: '₹ ',
              ),
            ),
            AppSpacing.h16,

            // ── Merchant Name ──
            TextField(
              controller: _merchantController,
              decoration: const InputDecoration(
                labelText: 'Merchant / Description *',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                hintText: 'e.g., Swiggy, Salary',
              ),
            ),
            AppSpacing.h16,

            // ── Category Dropdown ──
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category *',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              ),
              items: kTransactionCategories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            AppSpacing.h16,

            // ── Account Source (optional) ──
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(
                labelText: 'Account / Source (optional)',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                hintText: 'e.g., HDFC Bank, Cash',
              ),
            ),
            AppSpacing.h16,

            // ── Date Picker ──
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: const Text(
                'Transaction Date',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                DateFormat('d MMMM yyyy').format(_selectedDate),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 2)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),

            // ── Error Message ──
            if (_errorMsg != null) ...[
              AppSpacing.h8,
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            AppSpacing.h24,

            // ── Submit Button ──
            FilledButton(
              onPressed: _isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor:
                    _isIncome ? AppColors.success : theme.colorScheme.primary,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isIncome
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isIncome
                              ? 'Record Income'
                              : 'Record Expense',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
            AppSpacing.h16,
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final amountText = _amountController.text.trim().replaceAll(',', '');
    final amount = double.tryParse(amountText);

    final input = ManualTransactionInput(
      amount: amount ?? 0,
      merchantName: _merchantController.text.trim(),
      category: _selectedCategory,
      isIncome: _isIncome,
      occurredAt: _selectedDate,
      accountSource: _accountController.text.trim().isNotEmpty
          ? _accountController.text.trim()
          : 'Manual Entry',
    );

    final useCase = ref.read(addManualTransactionUseCaseProvider);
    final result = await useCase.execute(input);

    if (!mounted) return;

    switch (result) {
      case ManualTransactionSuccess():
        Navigator.pop(context, true);
      case ManualTransactionValidationError(:final message):
        setState(() {
          _isLoading = false;
          _errorMsg = message;
        });
      case ManualTransactionDbError(:final message):
        setState(() {
          _isLoading = false;
          _errorMsg = 'Failed to save: $message';
        });
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.12)
              : Theme.of(context).cardColor,
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: isSelected
                ? selectedColor
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? selectedColor : Theme.of(context).hintColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : Theme.of(context).hintColor,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
