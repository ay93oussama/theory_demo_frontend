import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';

/// Shared pressed feedback, with keyboard/semantics handling supplied by InkWell.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.pressedScale,
    required this.onTap,
    this.background = AppColors.transparent,
    this.pressedBackground = AppColors.surface,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double pressedScale;
  final VoidCallback? onTap;
  final Color background;
  final Color pressedBackground;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      child: AnimatedScale(
        scale: _pressed && !reduceMotion ? widget.pressedScale : 1,
        duration: reduceMotion ? AppMotion.none : AppMotion.press,
        child: Material(
          color: _pressed ? widget.pressedBackground : widget.background,
          borderRadius: widget.borderRadius,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
            borderRadius: widget.borderRadius,
            splashFactory: NoSplash.splashFactory,
            highlightColor: AppColors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
