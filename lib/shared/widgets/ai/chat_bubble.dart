import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/ai_theme_extension.dart';

/// Reusable conversation bubble displaying chat dialogues for User vs AI.
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    required this.text,
    required this.isUser,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiTheme = theme.extension<AiThemeExtension>()!;

    final formattedTime = timestamp.toString().substring(11, 16);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: AppSpacing.paddingMd + AppSpacing.paddingHorizontalMd,
        decoration: BoxDecoration(
          color: isUser
              ? aiTheme.userBubbleColor
              : aiTheme.assistantBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: Radius.circular(isUser ? 16.0 : 4.0),
            bottomRight: Radius.circular(isUser ? 4.0 : 16.0),
          ),
          border: isUser
              ? null
              : Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isUser
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
            AppSpacing.h4,
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formattedTime,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color:
                      (isUser
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant)
                          .withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
