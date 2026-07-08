import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Reusable container with sliding linear gradient for shimmer load states.
/// Utilizes flutter_hooks for clean animation lifecycle handling.
class ShimmerContainer extends HookWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerContainer({
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    useEffect(() {
      controller.repeat();
      return null;
    }, []);

    final baseColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1F1F23)
        : const Color(0xFFE5E7EB);

    final highlightColor = theme.brightness == Brightness.dark
        ? const Color(0xFF2D2E33)
        : const Color(0xFFF3F4F6);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (controller.value - 0.3).clamp(0.0, 1.0),
                controller.value,
                (controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
