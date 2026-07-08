import 'package:flutter/material.dart';

/// Custom theme properties for the AI Assistant interface.
class AiThemeExtension extends ThemeExtension<AiThemeExtension> {
  final Gradient aiGradient;
  final Color userBubbleColor;
  final Color assistantBubbleColor;
  final Color glowColor;

  const AiThemeExtension({
    required this.aiGradient,
    required this.userBubbleColor,
    required this.assistantBubbleColor,
    required this.glowColor,
  });

  @override
  AiThemeExtension copyWith({
    Gradient? aiGradient,
    Color? userBubbleColor,
    Color? assistantBubbleColor,
    Color? glowColor,
  }) {
    return AiThemeExtension(
      aiGradient: aiGradient ?? this.aiGradient,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
      assistantBubbleColor: assistantBubbleColor ?? this.assistantBubbleColor,
      glowColor: glowColor ?? this.glowColor,
    );
  }

  @override
  AiThemeExtension lerp(ThemeExtension<AiThemeExtension>? other, double t) {
    if (other is! AiThemeExtension) return this;
    return AiThemeExtension(
      aiGradient: Gradient.lerp(aiGradient, other.aiGradient, t) ?? aiGradient,
      userBubbleColor:
          Color.lerp(userBubbleColor, other.userBubbleColor, t) ??
          userBubbleColor,
      assistantBubbleColor:
          Color.lerp(assistantBubbleColor, other.assistantBubbleColor, t) ??
          assistantBubbleColor,
      glowColor: Color.lerp(glowColor, other.glowColor, t) ?? glowColor,
    );
  }
}
