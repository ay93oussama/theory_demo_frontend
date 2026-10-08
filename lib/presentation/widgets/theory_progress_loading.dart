import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'engine_loader.dart';

/// Loading visuals only; the Cubit owns request timing and state transitions.
class TheoryProgressLoading extends StatefulWidget {
  const TheoryProgressLoading({super.key});

  @override
  State<TheoryProgressLoading> createState() => _TheoryProgressLoadingState();
}

class _TheoryProgressLoadingState extends State<TheoryProgressLoading>
    with TickerProviderStateMixin {
  late final _fade = AnimationController(
    vsync: this,
    duration: AppMotion.loadingFade,
  );
  late final _rpm = AnimationController(
    vsync: this,
    duration: AppMotion.rpmCycle,
  );
  late final _spinner = AnimationController(
    vsync: this,
    duration: AppMotion.spinnerCycle,
  );
  late final _skeleton = AnimationController(
    vsync: this,
    duration: AppMotion.skeletonCycle,
  );
  late final _rpmValue = AppMotion.rpm.animate(_rpm);
  late final _fadeValue = _fade.drive(
    CurveTween(curve: AppMotion.loadingCurve),
  );
  late final _skeletonOpacity = AppMotion.skeletonOpacity.animate(_skeleton);
  bool? _reduceMotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion == _reduceMotion) return;
    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _fade.value = 1;
      for (final controller in [_rpm, _spinner, _skeleton]) {
        controller.value = 0;
      }
    } else {
      _fade.forward();
      for (final controller in [_rpm, _spinner, _skeleton]) {
        controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in [_fade, _rpm, _spinner, _skeleton]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    label: AppStrings.loaderStep3,
    excludeSemantics: true,
    child: FadeTransition(
      opacity: _fadeValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radius28),
              boxShadow: AppDimensions.heroShadows,
            ),
            child: Padding(
              padding: AppDimensions.loaderPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          AppStrings.loaderLabel,
                          style: AppText.label,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusPill,
                          ),
                        ),
                        child: Padding(
                          padding: AppDimensions.loaderPillPadding,
                          child: Text(
                            AppStrings.loaderEngine,
                            style: AppText.loaderPill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space18),
                  Container(
                    height: AppDimensions.enginePanelHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius22,
                      ),
                      gradient: AppDimensions.enginePanelGradient,
                    ),
                    child: const Center(child: EngineLoader()),
                  ),
                  const SizedBox(height: AppDimensions.space18),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.loaderTitle,
                          style: AppText.loaderTitle,
                        ),
                      ),
                      SizedBox(width: AppDimensions.space12),
                      Text(AppStrings.loaderRpm, style: AppText.rpm),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.rpmRadius,
                    ),
                    child: SizedBox(
                      height: AppDimensions.rpmHeight,
                      child: ColoredBox(
                        color: AppColors.track,
                        child: AnimatedBuilder(
                          animation: _rpmValue,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.rpmRadius,
                              ),
                            ),
                          ),
                          builder: (_, child) => FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _rpmValue.value,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space20),
                  const _ChecklistRow(label: AppStrings.loaderStep1),
                  const SizedBox(height: AppDimensions.space10),
                  const _ChecklistRow(label: AppStrings.loaderStep2),
                  const SizedBox(height: AppDimensions.space10),
                  _ChecklistRow(
                    label: AppStrings.loaderStep3,
                    spinner: _spinner,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          FadeTransition(
            opacity: _skeletonOpacity,
            child: Container(
              height: AppDimensions.skeletonHeight,
              decoration: BoxDecoration(
                color: AppColors.skeleton,
                borderRadius: BorderRadius.circular(AppDimensions.radius22),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.label, this.spinner});

  final String label;
  final Animation<double>? spinner;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox.square(
        dimension: AppDimensions.loaderStepSize,
        child: spinner != null
            ? RotationTransition(
                turns: spinner!,
                child: const CustomPaint(painter: _SpinnerPainter()),
              )
            : DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    AppStrings.checkMark,
                    style: AppText.loaderCheck,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
      ),
      const SizedBox(width: AppDimensions.space12),
      Expanded(child: Text(label, style: AppText.checklist)),
    ],
  );
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(
      AppDimensions.loaderSpinnerStroke / 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.loaderSpinnerStroke
      ..color = AppColors.spinnerTrack;
    canvas.drawOval(rect, paint);
    paint.color = AppColors.primary;
    canvas.drawArc(rect, -3 * math.pi / 4, math.pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) => false;
}
