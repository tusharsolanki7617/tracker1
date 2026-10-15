import 'package:flutter/material.dart';

/// ============================================================================
/// APP ANIMATIONS — Reusable motion around local animation artwork.
/// ============================================================================
class AppAnimations {
  AppAnimations._();

  static const String _base = 'lib/resource/animations';

  /// Continuously rotating loading artwork.
  static const String loading = '$_base/loading.png';

  /// Success checkmark artwork.
  static const String success = '$_base/success.png';

  static Widget loadingWidget({double size = 48}) =>
      _LoadingAnimation(size: size);

  static Widget successWidget({double size = 24}) => TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.7, end: 1),
    duration: const Duration(milliseconds: 420),
    curve: Curves.easeOutBack,
    builder: (context, scale, child) => Transform.scale(
      scale: scale,
      child: child,
    ),
    child: Image.asset(
      success,
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
}

class _LoadingAnimation extends StatefulWidget {
  final double size;

  const _LoadingAnimation({required this.size});

  @override
  State<_LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<_LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: _controller,
    child: Image.asset(
      AppAnimations.loading,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
    ),
  );
}
