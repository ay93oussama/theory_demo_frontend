import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';

/// Decorative gauge. The enclosing card supplies a stable semantic description.
class ProgressGauge extends StatefulWidget {
  const ProgressGauge({
    required this.progress,
    required this.isComplete,
    super.key,
  }) : assert(progress >= 0 && progress <= 1);

  final double progress;
  final bool isComplete;

  @override
  State<ProgressGauge> createState() => _ProgressGaugeState();
}

class _ProgressGaugeState extends State<ProgressGauge>
    with TickerProviderStateMixin {
  late final _positionController = AnimationController(
    vsync: this,
    duration: AppMotion.gauge,
  );
  late final _colorController = AnimationController(
    vsync: this,
    duration: AppMotion.color,
  );
  late final _positionCurve = CurvedAnimation(
    parent: _positionController,
    curve: AppMotion.emphasized,
  );
  late Animation<double> _position = Tween<double>(
    begin: 0,
    end: widget.progress,
  ).animate(_positionCurve);
  late Animation<Color?> _color = AlwaysStoppedAnimation(_accent);
  Timer? _delay;
  bool _initialized = false;
  bool _reduceMotion = false;

  Color get _accent =>
      widget.isComplete ? AppColors.success : AppColors.primary;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _delay?.cancel();
      _delay = null;
      _positionController.value = 1;
      _colorController.value = 1;
    } else if (!_initialized) {
      _delay = Timer(AppMotion.gaugeDelay, () {
        _delay = null;
        _positionController.forward();
      });
    }
    _initialized = true;
  }

  @override
  void didUpdateWidget(covariant ProgressGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _position = Tween<double>(
        begin: _position.value,
        end: widget.progress,
      ).animate(_positionCurve);
      _positionController.value = _reduceMotion ? 1 : 0;
      if (!_reduceMotion && _delay == null) _positionController.forward();
    }
    if (oldWidget.isComplete != widget.isComplete) {
      _color = ColorTween(
        begin: _color.value,
        end: _accent,
      ).animate(_colorController);
      _colorController.value = _reduceMotion ? 1 : 0;
      if (!_reduceMotion) _colorController.forward();
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    _positionCurve.dispose();
    _positionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: RepaintBoundary(
      child: SizedBox.fromSize(
        size: AppDimensions.gaugeSize,
        child: CustomPaint(
          painter: _GaugePainter(position: _position, color: _color),
        ),
      ),
    ),
  );
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.position, required this.color})
    : super(repaint: Listenable.merge([position, color]));

  final Animation<double> position;
  final Animation<Color?> color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
      size.width / AppDimensions.gaugeViewBox.width,
      size.height / AppDimensions.gaugeViewBox.height,
    );
    final arc = Rect.fromCircle(
      center: AppDimensions.gaugeCenter,
      radius: AppDimensions.gaugeRadius,
    );
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = AppDimensions.gaugeStroke
      ..color = AppColors.track;
    canvas.drawArc(arc, math.pi, math.pi, false, stroke);
    // A zero-length round-capped stroke would leave an unwanted colored dot.
    if (position.value > 0) {
      stroke.color = color.value!;
      canvas.drawArc(arc, math.pi, math.pi * position.value, false, stroke);
    }
    final tickArc = Rect.fromCircle(
      center: AppDimensions.gaugeCenter,
      radius: AppDimensions.gaugeTickRadius,
    );
    stroke
      ..color = AppColors.gaugeTicks
      ..strokeWidth = AppDimensions.gaugeTickStroke
      ..strokeCap = StrokeCap.butt;
    final length = math.pi * AppDimensions.gaugeTickRadius;
    for (
      var offset = 0.0;
      offset < length;
      offset += AppDimensions.gaugeTickLength + AppDimensions.gaugeTickGap
    ) {
      canvas.drawArc(
        tickArc,
        math.pi + offset / AppDimensions.gaugeTickRadius,
        math.min(AppDimensions.gaugeTickLength, length - offset) /
            AppDimensions.gaugeTickRadius,
        false,
        stroke,
      );
    }
    canvas.restore();

    canvas.save();
    canvas.scale(
      size.width / AppDimensions.gaugeSize.width,
      size.height / AppDimensions.gaugeSize.height,
    );
    canvas.save();
    canvas.translate(
      AppDimensions.gaugeNeedlePivot.dx,
      AppDimensions.gaugeNeedlePivot.dy,
    );
    canvas.rotate(math.pi * (position.value - .5));
    final fill = Paint()..color = AppColors.ink;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -AppDimensions.gaugeNeedleWidth / 2,
          -AppDimensions.gaugeNeedleLength,
          AppDimensions.gaugeNeedleWidth,
          AppDimensions.gaugeNeedleLength,
        ),
        const Radius.circular(AppDimensions.radiusPill),
      ),
      fill,
    );
    canvas.restore();
    fill.color = AppColors.surface;
    canvas.drawCircle(
      AppDimensions.gaugeHubCenter,
      AppDimensions.gaugeHubRadius + AppDimensions.gaugeHubRing,
      fill,
    );
    fill.color = AppColors.ink;
    canvas.drawCircle(
      AppDimensions.gaugeHubCenter,
      AppDimensions.gaugeHubRadius,
      fill,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      position != oldDelegate.position || color != oldDelegate.color;
}
