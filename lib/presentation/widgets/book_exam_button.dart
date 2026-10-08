import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'pressable.dart';

/// The prototype booking action owns one toast, removed with this widget.
class BookExamButton extends StatefulWidget {
  const BookExamButton({super.key});

  @override
  State<BookExamButton> createState() => _BookExamButtonState();
}

class _BookExamButtonState extends State<BookExamButton>
    with SingleTickerProviderStateMixin {
  final _overlay = OverlayPortalController();
  late final AnimationController _animation;
  late final CurvedAnimation _curve;
  Timer? _timer;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: AppMotion.toast)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) _overlay.hide();
      });
    _curve = CurvedAnimation(parent: _animation, curve: AppMotion.emphasized);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion && _overlay.isShowing) _animation.value = 1;
  }

  void _showToast() {
    _timer?.cancel();
    _overlay.show();
    final entrance = _reduceMotion || _animation.isCompleted
        ? AppMotion.none
        : AppMotion.toast;
    if (_reduceMotion) {
      _animation.value = 1;
    } else {
      _animation.forward();
    }
    _timer = Timer(entrance + AppMotion.toastVisible, () {
      if (_reduceMotion) {
        _animation.value = 0;
      } else {
        _animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _curve.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _overlay,
    overlayChildBuilder: (context) => Positioned(
      left: AppDimensions.space20,
      right: AppDimensions.space20,
      bottom:
          AppDimensions.toastBottom + MediaQuery.viewInsetsOf(context).bottom,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _curve,
          child: AnimatedBuilder(
            animation: _curve,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, AppDimensions.toastRise * (1 - _curve.value)),
              child: child,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.toastMaxWidth,
                ),
                child: Semantics(
                  liveRegion: true,
                  container: true,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius14,
                      ),
                      boxShadow: AppDimensions.toastShadows,
                    ),
                    child: const Padding(
                      padding: AppDimensions.toastPadding,
                      child: Text(
                        AppStrings.bookToast,
                        textAlign: TextAlign.center,
                        style: AppText.toast,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    child: Pressable(
      borderRadius: BorderRadius.circular(AppDimensions.radius16),
      pressedScale: AppMotion.actionPressedScale,
      onTap: _showToast,
      background: AppColors.success,
      pressedBackground: AppColors.successPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: AppDimensions.bookingHeight,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space12,
          ),
          child: Center(
            child: Text(
              AppStrings.bookExam,
              style: AppText.button,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );
}
