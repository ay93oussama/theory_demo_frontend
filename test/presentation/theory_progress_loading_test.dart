import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/theme/app_dimensions.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/presentation/widgets/theory_progress_loading.dart';

void main() {
  test(
    'engine keeps its 56px travel, alternating phase, and spark keyframes',
    () {
      for (final (phase, left, right) in [
        (0.0, 0.0, 56.0),
        (.5, 56.0, 0.0),
        (1.0, 0.0, 56.0),
      ]) {
        expect(AppMotion.pistonOffset.transform(phase).dy, closeTo(left, .001));
        expect(
          AppMotion.pistonOffset
              .transform(AppMotion.engineHalfCycle.transform(phase))
              .dy,
          closeTo(right, .001),
        );
      }
      expect(AppMotion.sparkOpacity.transform(0), 0);
      expect(AppMotion.sparkOpacity.transform(.8), 0);
      expect(AppMotion.sparkOpacity.transform(.88), closeTo(1, .001));
      expect(AppMotion.sparkOpacity.transform(1), 0);
      final rightSpark = AppMotion.sparkOpacity.transform(
        AppMotion.engineHalfCycle.transform(.38),
      );
      expect(rightSpark, closeTo(1, .001));
      expect(AppMotion.sparkScale.transform(0), .6);
      expect(AppMotion.sparkScale.transform(rightSpark), closeTo(1.4, .001));
    },
  );

  testWidgets(
    'loading animates, responds to reduced motion, and disposes cleanly',
    (tester) async {
      await _pump(tester);
      await tester.pump(AppMotion.loadingFade);
      expect(find.text('Motor startet…'), findsOneWidget);
      expect(find.text('Kraftstoffpumpe bereit'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Theorie-Fortschritt wird geladen'),
        findsOneWidget,
      );
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(AppMotion.engineCycle);
      expect(tester.takeException(), isNull);

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
      expect(find.text('Theorie-Fortschritt wird geladen'), findsOneWidget);

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures();
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(AppMotion.rpmCycle);
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('loading remains readable at 2x text with motion disabled', (
    tester,
  ) async {
    await _pump(tester, textScale: 2, reduceMotion: true);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Theorie-Fortschritt wird geladen'));
    expect(find.text('Zündung an'), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  double textScale = 1,
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = const Size(440, 956);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: reduceMotion);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  await tester.pumpWidget(
    TheoryProgressApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: AppDimensions.screenPadding,
            children: const [TheoryProgressLoading()],
          ),
        ),
      ),
    ),
  );
}
