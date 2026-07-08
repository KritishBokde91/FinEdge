import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/app_animations.dart';

/// Animation wrapper that fades and slides a widget up on screen entrance.
/// Utilizes flutter_hooks for clean animation controller rendering.
class FadeSlideEntrance extends HookWidget {
  final Widget child;
  final double startOffset;
  final Duration duration;

  const FadeSlideEntrance({
    required this.child,
    this.startOffset = 24.0,
    this.duration = AppAnimations.durationNormal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    final opacityAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: AppAnimations.curveNormal),
      ),
    );

    final slideAnimation = useAnimation(
      Tween<double>(begin: startOffset, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: AppAnimations.curveFluid),
      ),
    );

    return Opacity(
      opacity: opacityAnimation,
      child: Transform.translate(
        offset: Offset(0.0, slideAnimation),
        child: child,
      ),
    );
  }
}

/// Animation wrapper that scales a widget up on screen entrance.
/// Useful for buttons, FABs, or dialog indicators.
class ScaleEntrance extends HookWidget {
  final Widget child;
  final double startScale;
  final Duration duration;

  const ScaleEntrance({
    required this.child,
    this.startScale = 0.8,
    this.duration = AppAnimations.durationFast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    final scaleAnimation = useAnimation(
      Tween<double>(begin: startScale, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: AppAnimations.curveBouncy),
      ),
    );

    return Transform.scale(scale: scaleAnimation, child: child);
  }
}
