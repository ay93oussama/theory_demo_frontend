import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/core/constants/app_strings.dart';
import 'package:theory_demo_frontend/core/theme/app_dimensions.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/presentation/widgets/gauge_card.dart';
import 'package:theory_demo_frontend/presentation/widgets/progress_gauge.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('complete card shows German completion and accessible totals', (
    tester,
  ) async {
    await _pump(tester, _completeCard());
    await tester.pump(AppMotion.gaugeDelay);
    await tester.pumpAndSettle();

    expect(find.text('Theorie erledigt ✓'), findsOneWidget);
    expect(find.text('Erledigt'), findsOneWidget);
    expect(find.text(AppStrings.gaugeCompleteNextStep), findsOneWidget);
    expect(find.textContaining('/ 14 Unterrichte'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Theorie-Fortschritt: 14 von 14 Unterrichten besucht. Erledigt',
      ),
      findsOneWidget,
    );
    final gauge = find.byType(ProgressGauge);
    final cardCenter = tester.getCenter(find.byType(GaugeCard)).dx;
    expect(tester.getCenter(gauge).dx, closeTo(cardCenter, .5));
    expect(
      tester.getCenter(find.text(AppStrings.gaugeCompleteNextStep)).dx,
      closeTo(cardCenter, .5),
    );
    expect(
      tester.getBottomLeft(find.text(AppStrings.headlineDone)).dy,
      lessThan(tester.getTopLeft(gauge).dy),
    );
    expect(
      tester.getBottomLeft(gauge).dy,
      lessThan(tester.getTopLeft(find.textContaining('/ 14 Unterrichte')).dy),
    );
    expect(
      tester.getBottomLeft(find.textContaining('/ 14 Unterrichte')).dy,
      lessThan(
        tester.getTopLeft(find.text(AppStrings.gaugeCompleteNextStep)).dy,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text and reduced motion show final state immediately', (
    tester,
  ) async {
    // Different requirements guard against a fixed total in the widget.
    await _pump(
      tester,
      _completeCard(total: 8),
      textScale: 2,
      reduceMotion: true,
      width: 320,
    );
    expect(find.textContaining('/ 8 Unterrichte'), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('full attendance alone does not show booking guidance', (
    tester,
  ) async {
    await _pump(
      tester,
      GaugeCard(
        progress: 1,
        isComplete: false,
        totalLabel: '14',
        totalSuffix: AppStrings.totalSuffix(14),
        statusLabel: AppStrings.pillInProgress,
        headline: AppStrings.pillInProgress,
        subline: AppStrings.subBasicDone,
        semanticsLabel: AppStrings.gaugeSemantics(
          14,
          14,
          AppStrings.pillInProgress,
        ),
      ),
      reduceMotion: true,
    );

    expect(find.text(AppStrings.gaugeCompleteNextStep), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'gauge delays, animates, handles updates, and cancels on removal',
    (tester) async {
      await _pump(tester, const ProgressGauge(progress: .5, isComplete: false));
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pump(AppMotion.gaugeDelay);
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(AppMotion.gauge ~/ 2);
      await _pump(tester, const ProgressGauge(progress: 1, isComplete: true));
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox());
      await _pump(tester, const ProgressGauge(progress: 0, isComplete: false));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(AppMotion.gaugeDelay + AppMotion.gauge);
      expect(tester.takeException(), isNull);
    },
  );
}

GaugeCard _completeCard({int total = 14}) => GaugeCard(
  progress: 1,
  isComplete: true,
  totalLabel: total.toString(),
  totalSuffix: AppStrings.totalSuffix(total),
  statusLabel: AppStrings.pillComplete,
  headline: AppStrings.headlineDone,
  subline: AppStrings.subDone(total),
  semanticsLabel: AppStrings.gaugeSemantics(
    total,
    total,
    AppStrings.pillComplete,
  ),
);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    TestApp(
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reduceMotion,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: AppDimensions.screenPadding,
            child: child,
          ),
        ),
      ),
    ),
  );
}
