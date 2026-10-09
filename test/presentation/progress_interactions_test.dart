import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/constants/app_strings.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/presentation/widgets/app_modal_sheet.dart';
import 'package:theory_demo_frontend/presentation/widgets/book_exam_button.dart';
import 'package:theory_demo_frontend/presentation/widgets/next_step_row.dart';
import 'package:theory_demo_frontend/presentation/widgets/road_sheet.dart';

void main() {
  testWidgets(
    'booking shows one German toast; repeated taps restart its lifetime',
    (tester) async {
      await _pump(tester, complete: true);
      await tester.tap(find.text('Theorieprüfung buchen →'));
      await tester.pumpAndSettle();
      expect(
        find.text('Die Prüfungsbuchung ist nicht Teil dieses Prototyps'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text('Theorieprüfung buchen →'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(AppStrings.bookToast), findsOneWidget);
      await tester.pump(AppMotion.toastVisible);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.bookToast), findsNothing);
      expect(find.text(AppStrings.bookExam), findsOneWidget);

      await tester.tap(find.text(AppStrings.bookExam));
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(AppMotion.toastVisible + AppMotion.toast);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'incomplete road uses current/locked steps and all dismissal methods',
    (tester) async {
      await _pump(tester);
      expect(find.byType(BookExamButton), findsNothing);
      Future<void> open() async {
        await tester.tap(find.text(AppStrings.nextTitle));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.roadTitle), findsOneWidget);
      }

      await open();
      expect(
        find.bySemanticsLabel(
          'Schritt 1: Theorieunterricht. 9 von 14 besucht. Aktueller Schritt',
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          'Schritt 2: Theorieprüfung. Wird freigeschaltet, sobald die Theorie erledigt ist. Noch gesperrt',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Schließen'));
      await tester.pumpAndSettle();
      expect(find.byType(RoadSheet), findsNothing);

      await open();
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(find.byType(RoadSheet), findsNothing);

      await open();
      await tester.fling(
        find.text(AppStrings.roadTitle),
        const Offset(0, 400),
        1200,
      );
      await tester.pumpAndSettle();
      expect(find.byType(RoadSheet), findsNothing);
    },
  );

  testWidgets(
    'completed road remains dismissible at 3x text with reduced motion',
    (tester) async {
      await _pump(tester, complete: true, textScale: 3, reduceMotion: true);
      await tester.tap(find.text(AppStrings.nextTitle));
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel('Schritt 1: Theorieunterricht. Abgeschlossen'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          'Schritt 2: Theorieprüfung. Bereit zur Buchung. Aktueller Schritt',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text(AppStrings.step4Title));
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text(AppStrings.roadTitle));
      await tester.fling(
        find.text(AppStrings.roadTitle),
        const Offset(0, 400),
        1200,
      );
      await tester.pumpAndSettle();
      expect(find.byType(RoadSheet), findsNothing);
      await tester.tap(find.text(AppStrings.bookExam));
      await tester.pump();
      expect(find.text(AppStrings.bookToast), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pump(AppMotion.toastVisible);
      expect(find.text(AppStrings.bookToast), findsNothing);
    },
  );
}

Future<void> _pump(
  WidgetTester tester, {
  bool complete = false,
  double textScale = 1,
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = const Size(440, 956);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: reduceMotion);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    TheoryProgressApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                if (complete) const BookExamButton(),
                NextStepRow(
                  isReady: complete,
                  onTap: () => showAppModalSheet(
                    context: context,
                    builder: (_) => RoadSheet(
                      lessonsStatus: complete
                          ? RoadStepStatus.done
                          : RoadStepStatus.current,
                      examStatus: complete
                          ? RoadStepStatus.current
                          : RoadStepStatus.locked,
                      lessonsMeta: complete
                          ? AppStrings.step1Done
                          : AppStrings.step1Meta(9, 14),
                      examMeta: complete
                          ? AppStrings.nextReady
                          : AppStrings.nextLocked,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
