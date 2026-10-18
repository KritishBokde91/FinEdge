import 'package:flutter/material.dart';

/// Horizontal scrollable row of quick-action suggestion chips.
class QuickChipsWidget extends StatelessWidget {
  final void Function(String query) onChipTapped;

  const QuickChipsWidget({super.key, required this.onChipTapped});

  static const _chips = [
    ('📊 Monthly Summary', 'Give me a financial summary for this month'),
    ('💸 Top Spending', 'What are my top spending categories this month?'),
    ('🎯 Budget Check', 'How are my budgets doing?'),
    ('🏆 Savings Goals', 'Show me my savings goals progress'),
    ('📈 Spending Trend', 'Show my spending trend for the last 3 months'),
    ('🏪 Top Merchants', 'Which merchants am I spending the most on?'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (label, query) = _chips[index];
          return ActionChip(
            label: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            side: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            onPressed: () => onChipTapped(query),
          );
        },
      ),
    );
  }
}
