import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/ai_theme_extension.dart';
import '../cards/glass_card.dart';

/// A card container with gradient borders and glowing backdrops for AI highlights.
class AiInsightCard extends StatelessWidget {
  final String title;
  final String content;
  final Widget? action;

  const AiInsightCard({
    required this.title,
    required this.content,
    this.action = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiTheme = theme.extension<AiThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: aiTheme.glowColor, blurRadius: 24, spreadRadius: -4),
        ],
      ),
      child: GlassCard(
        padding: AppSpacing.paddingLg,
        tintColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1B4B)
            : const Color(0xFFEEF2F6),
        opacity: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      aiTheme.aiGradient.createShader(bounds),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                AppSpacing.w8,
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.h12,
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            if (action != null) ...[
              AppSpacing.h16,
              Align(alignment: Alignment.centerRight, child: action!),
            ],
          ],
        ),
      ),
    );
  }
}
