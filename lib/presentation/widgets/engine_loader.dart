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
  late final AnimationController _cycle;
  late final Animation<Offset> _leftPiston;
  late final Animation<Offset> _rightPiston;
  late final Animation<double> _leftSparkOpacity;
  late final Animation<double> _rightSparkOpacity;
  late final Animation<double> _leftSparkScale;
  late final Animation<double> _rightSparkScale;
  bool? _reduceMotion;

  @override
  void initState() {
    super.initState();
    _cycle = AnimationController(vsync: this, duration: AppMotion.engineCycle);
    final rightCycle = _cycle.drive(AppMotion.engineHalfCycle);
    _leftPiston = _cycle.drive(AppMotion.pistonOffset);
    _rightPiston = rightCycle.drive(AppMotion.pistonOffset);
    _leftSparkOpacity = _cycle.drive(AppMotion.sparkOpacity);
    _rightSparkOpacity = rightCycle.drive(AppMotion.sparkOpacity);
    _leftSparkScale = _leftSparkOpacity.drive(AppMotion.sparkScale);
    _rightSparkScale = _rightSparkOpacity.drive(AppMotion.sparkScale);
  }

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
            _Cylinder(
              angle: AppMotion.engineLeftTilt,
              pistonOffset: _leftPiston,
              sparkOpacity: _leftSparkOpacity,
              sparkScale: _leftSparkScale,
            ),
            _Cylinder(
              angle: AppMotion.engineRightTilt,
              pistonOffset: _rightPiston,
              sparkOpacity: _rightSparkOpacity,
              sparkScale: _rightSparkScale,
            ),
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
  const _Cylinder({
    required this.angle,
    required this.pistonOffset,
    required this.sparkOpacity,
    required this.sparkScale,
  });

  final double angle;
  final Animation<Offset> pistonOffset;
  final Animation<double> sparkOpacity;
  final Animation<double> sparkScale;

  @override
  Widget build(BuildContext context) => Positioned.fromRect(
    rect: AppDimensions.engineCylinderRect,
    child: Transform.rotate(
      angle: angle,
      alignment: AppDimensions.engineCylinderPivot,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fromRect(
            rect: AppDimensions.engineSparkRect,
            child: FadeTransition(
              opacity: sparkOpacity,
              child: ScaleTransition(
                scale: sparkScale,
                child: const _EngineImage(AppAssets.engineSpark),
              ),
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
                      animation: pistonOffset,
                      child: const _EngineImage(AppAssets.enginePiston),
                      builder: (_, child) => Transform.translate(
                        offset: pistonOffset.value,
                        child: child,
                      ),
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
