import 'dart:math' as math;

import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const emphasized = Cubic(.2, .8, .2, 1);
  static const engineCurve = Curves.easeInOut;
  static const linear = Curves.linear;
  static const loadingCurve = Curves.ease;
  static const none = Duration.zero;
  static const press = Duration(milliseconds: 120);
  static const disclosure = Duration(milliseconds: 200);
  static const studentMenu = Duration(milliseconds: 180);

  static const toast = Duration(milliseconds: 250);
  static const scrim = Duration(milliseconds: 250);
  static const loadingFade = Duration(milliseconds: 300);
  static const dataFade = Duration(milliseconds: 350);
  static const sheet = Duration(milliseconds: 320);
  static final sheetScrimCurve = Interval(
    0,
    scrim.inMicroseconds / sheet.inMicroseconds,
    curve: Curves.ease,
  );
  static const color = Duration(milliseconds: 400);
  static const gauge = Duration(milliseconds: 900);
  static const gaugeDelay = Duration(milliseconds: 80);
  static const minimumLoading = Duration(milliseconds: 800);
  static const timestampInterval = Duration(minutes: 1);
  static const engineCycle = Duration(milliseconds: 1200);
  static const spinnerCycle = Duration(milliseconds: 900);
  static const rpmCycle = Duration(milliseconds: 2400);
  static const skeletonCycle = Duration(milliseconds: 1400);
  static const toastVisible = Duration(milliseconds: 2200);

  static const retryPressedScale = .97;
  static const actionPressedScale = .98;
  static const skeletonMinOpacity = .45;
  static const engineTiltDegrees = 34.0;
  static const engineLeftTilt = -engineTiltDegrees * math.pi / 180;
  static const engineRightTilt = engineTiltDegrees * math.pi / 180;
  static const pistonTravel = 56.0;
  static const sparkStart = .8;
  static const sparkPeak = .88;
  static const sparkMinScale = .6;
  static const sparkMaxScale = 1.4;

  static const engineHalfCycle = _PhaseShift(.5);
  static final pistonOffset = TweenSequence<Offset>([
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, pistonTravel),
      ).chain(CurveTween(curve: engineCurve)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween<Offset>(
        begin: const Offset(0, pistonTravel),
        end: Offset.zero,
      ).chain(CurveTween(curve: engineCurve)),
      weight: 1,
    ),
  ]);
  static final sparkOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: sparkStart),
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0),
      weight: sparkPeak - sparkStart,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.0),
      weight: 1 - sparkPeak,
    ),
  ]);
  static final sparkScale = Tween(begin: sparkMinScale, end: sparkMaxScale);

  static final rpm = TweenSequence<double>([
    TweenSequenceItem(tween: _engineTween(.1, .85), weight: 45),
    TweenSequenceItem(tween: _engineTween(.85, .28), weight: 25),
    TweenSequenceItem(tween: _engineTween(.28, .32), weight: 30),
  ]);
  static final skeletonOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: _engineTween(1, skeletonMinOpacity), weight: 50),
    TweenSequenceItem(tween: _engineTween(skeletonMinOpacity, 1), weight: 50),
  ]);

  static Animatable<double> _engineTween(double begin, double end) =>
      Tween<double>(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: engineCurve));
}

/// Keeps the second cylinder half a cycle behind, including at the loop boundary.
class _PhaseShift extends Animatable<double> {
  const _PhaseShift(this.offset);
  final double offset;

  @override
  double transform(double t) => (t + offset) % 1;
}
