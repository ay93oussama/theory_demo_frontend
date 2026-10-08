import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';

/// Decorative PNG assembly. The loading view supplies its semantic description.
class EngineLoader extends StatefulWidget {
  const EngineLoader({super.key});

  @override
  State<EngineLoader> createState() => _EngineLoaderState();
}

class _EngineLoaderState extends State<EngineLoader>
    with SingleTickerProviderStateMixin {
  late final _cycle = AnimationController(
    vsync: this,
    duration: AppMotion.engineCycle,
  );
  bool? _reduceMotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion == _reduceMotion) return;
    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _cycle.value = 0;
    } else {
      _cycle.repeat();
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: RepaintBoundary(
      child: SizedBox.fromSize(
        size: AppDimensions.engineSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _Cylinder(cycle: _cycle, isRight: false),
            _Cylinder(cycle: _cycle, isRight: true),
            Positioned.fromRect(
              rect: AppDimensions.engineIntakeRect,
              child: const _EngineImage(AppAssets.engineIntake),
            ),
            Positioned.fromRect(
              rect: AppDimensions.engineBlockRect,
              child: const _EngineImage(AppAssets.engineBlock),
            ),
            Positioned.fromRect(
              rect: AppDimensions.enginePulleyRect,
              child: RotationTransition(
                turns: _cycle,
                child: const _EngineImage(AppAssets.enginePulley),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Cylinder extends StatelessWidget {
  const _Cylinder({required this.cycle, required this.isRight});

  final Animation<double> cycle;
  final bool isRight;

  double get _phase => (cycle.value + (isRight ? .5 : 0)) % 1;

  @override
  Widget build(BuildContext context) => Positioned.fromRect(
    rect: AppDimensions.engineCylinderRect,
    child: Transform.rotate(
      angle: AppMotion.engineTiltDegrees * (isRight ? 1 : -1) * math.pi / 180,
      alignment: AppDimensions.engineCylinderPivot,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fromRect(
            rect: AppDimensions.engineSparkRect,
            child: AnimatedBuilder(
              animation: cycle,
              child: const _EngineImage(AppAssets.engineSpark),
              builder: (_, child) {
                final phase = _phase;
                final glow = phase < AppMotion.sparkStart
                    ? 0.0
                    : phase < AppMotion.sparkPeak
                    ? (phase - AppMotion.sparkStart) /
                          (AppMotion.sparkPeak - AppMotion.sparkStart)
                    : (1 - phase) / (1 - AppMotion.sparkPeak);
                return Opacity(
                  opacity: glow.clamp(0, 1),
                  child: Transform.scale(
                    scale:
                        AppMotion.sparkMinScale +
                        (AppMotion.sparkMaxScale - AppMotion.sparkMinScale) *
                            glow,
                    child: child,
                  ),
                );
              },
            ),
          ),
          Positioned.fromRect(
            rect: AppDimensions.engineBodyRect,
            child: const _EngineImage(AppAssets.engineCylinder),
          ),
          Positioned.fromRect(
            rect: AppDimensions.engineBoreRect,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimensions.engineBoreRadius,
              ),
              child: Stack(
                children: [
                  Positioned.fromRect(
                    rect: AppDimensions.enginePistonRect,
                    child: AnimatedBuilder(
                      animation: cycle,
                      child: const _EngineImage(AppAssets.enginePiston),
                      builder: (_, child) {
                        final phase = _phase;
                        final travel = AppMotion.engineCurve.transform(
                          phase < .5 ? phase * 2 : 2 - phase * 2,
                        );
                        return Transform.translate(
                          offset: Offset(0, AppMotion.pistonTravel * travel),
                          child: child,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _EngineImage extends StatelessWidget {
  const _EngineImage(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    filterQuality: FilterQuality.medium,
    excludeFromSemantics: true,
  );
}
