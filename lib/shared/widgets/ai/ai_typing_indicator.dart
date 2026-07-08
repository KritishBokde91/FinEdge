import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions/ai_theme_extension.dart';

/// Animated three-jumping-dots indicator representing AI typing states.
/// Utilizes flutter_hooks for clean animation controller management.
class AiTypingIndicator extends HookWidget {
  const AiTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiTheme = theme.extension<AiThemeExtension>()!;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, []);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: aiTheme.assistantBubbleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(16.0),
          ),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                // Calculate staggered jump delay for each dot
                final delay = index * 0.2;
                double val = (controller.value - delay);
                if (val < 0) val += 1.0;
                if (val > 1.0) val -= 1.0;

                // Sine wave calculation for vertical jumping
                final jumpHeight =
                    -6.0 * (val < 0.5 ? (val * 2) : (1.0 - val) * 2);

                return Transform.translate(
                  offset: Offset(0, jumpHeight),
                  child: Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
