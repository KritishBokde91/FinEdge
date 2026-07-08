import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../cards/app_card.dart';

/// Renders a raw incoming SMS text in a conversational layout.
class SmsMessageCard extends StatelessWidget {
  final String sender;
  final String messageBody;
  final DateTime timestamp;

  const SmsMessageCard({
    required this.sender,
    required this.messageBody,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sender,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                timestamp.toString().substring(11, 16), // simple hh:mm fallback
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            ],
          ),
          AppSpacing.h8,
          Text(
            messageBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
