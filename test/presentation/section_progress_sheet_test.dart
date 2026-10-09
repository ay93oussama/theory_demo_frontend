import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/config/app_config.dart';
import 'package:theory_demo_frontend/core/constants/app_strings.dart';
import 'package:theory_demo_frontend/core/di/injection_container.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/core/theme/app_dimensions.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/entities/topic_progress.dart';
import 'package:theory_demo_frontend/domain/usecases/get_theory_progress_use_case.dart';
import 'package:theory_demo_frontend/presentation/cubits/theory_progress/theory_progress_cubit.dart';
import 'package:theory_demo_frontend/presentation/widgets/section_card.dart';
import 'package:theory_demo_frontend/presentation/widgets/section_progress_sheet.dart';
import 'package:theory_demo_frontend/presentation/widgets/section_segments.dart';

import '../support/progress_fixtures.dart';

void main() {
  tearDown(() => getIt.reset());

  testWidgets(
    'card opens answers, switches sections without fetching, and closes',
    (tester) async {
      final repo = FakeProgressRepository();
      await _pump(tester, repo);
      await _open(tester, AppStrings.sectionBasic);
      final sheet = find.byType(SectionProgressSheet);
      Finder inSheet(Finder finder) =>
          find.descendant(of: sheet, matching: finder);
      expect(inSheet(find.text('8 von 12 besucht')), findsOneWidget);
      expect(
        inSheet(find.textContaining('Noch 4 Unterrichte fehlen')),
        findsOneWidget,
      );
      expect(
        inSheet(find.text(AppStrings.sectionTimetableAnswer)),
        findsNothing,
      );
      await tester.tap(inSheet(find.text(AppStrings.sectionTimetableQuestion)));
      await tester.pumpAndSettle();
      expect(
        inSheet(find.text(AppStrings.sectionTimetableAnswer)),
        findsOneWidget,
      );
      expect(
        inSheet(find.textContaining('Noch 4 Unterrichte fehlen')),
        findsNothing,
      );
      await tester.tap(inSheet(find.text('Spezialstoff ansehen →')));
      await tester.pumpAndSettle();
      expect(sheet, findsOneWidget);
      expect(inSheet(find.text('1 von 2 besucht')), findsOneWidget);
      expect(
        inSheet(find.textContaining('Noch 1 Unterricht fehlt')),
        findsOneWidget,
      );
      expect(inSheet(find.text('Grundstoff ansehen →')), findsOneWidget);
      expect(repo.requests, ['1']);
      await tester.tap(inSheet(find.byTooltip(AppStrings.close)));
      await tester.pumpAndSettle();
      expect(sheet, findsNothing);
      await _open(tester, AppStrings.sectionSpecial);
      expect(inSheet(find.text('1 von 2 besucht')), findsOneWidget);
      await tester.tapAt(const Offset(20, 80));
      await tester.pumpAndSettle();
      expect(sheet, findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'completed chip aligns with heading and raw counts keep valid fill',
    (tester) async {
      final repo = FakeProgressRepository()
        ..handler = (_) async => Right(
          TheoryProgress(
            studentId: '1',
            studentName: 'Test',
            licenseClass: 'B',
            basicTopics: TopicProgress(attended: 15, required: 12),
            specialTopics: TopicProgress(attended: 3, required: 2),
            completed: true,
          ),
        );
      await _pump(tester, repo);
      await _open(tester, AppStrings.sectionSpecial);
      final sheet = find.byType(SectionProgressSheet);
      final heading = find.descendant(
        of: sheet,
        matching: find.text('Dein Fortschritt'),
      );
      final chip = find.descendant(
        of: sheet,
        matching: find.byKey(const ValueKey('section-sheet-status')),
      );
      expect(tester.widget<Text>(chip).data, 'Alles besucht');
      expect(
        tester.getCenter(chip).dy,
        closeTo(tester.getCenter(heading).dy, 1),
      );
      expect(
        tester.getCenter(chip).dx,
        greaterThan(tester.getCenter(heading).dx),
      );
      final chipContainer = find.descendant(
        of: sheet,
        matching: find.byKey(const ValueKey('section-sheet-chip')),
      );
      final summary = find.descendant(
        of: sheet,
        matching: find.byKey(const ValueKey('section-sheet-summary')),
      );
      expect(
        tester.getRect(chipContainer).right,
        closeTo(
          tester.getRect(summary).right -
              AppDimensions.sectionPadding.right -
              AppDimensions.borderWidth,
          1,
        ),
      );
      expect(
        find.descendant(of: sheet, matching: find.text('3 von 2 besucht')),
        findsOneWidget,
      );
      final segments = tester.widget<SectionSegments>(
        find.descendant(of: sheet, matching: find.byType(SectionSegments)),
      );
      expect(segments.filledCount, 2);
      await tester.tap(
        find.descendant(
          of: sheet,
          matching: find.text(AppStrings.sectionCompletionQuestion),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: sheet,
          matching: find.text(AppStrings.sectionTheoryDoneAnswer),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'zero and section-only completion respect dynamic API values and large text',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      for (final scenario in [(0, 0), (3, 0), (3, 1)]) {
        final repo = FakeProgressRepository()
          ..handler = (_) async => Right(
            TheoryProgress(
              studentId: '1',
              studentName: 'Test',
              licenseClass: 'B',
              basicTopics: TopicProgress(attended: scenario.$1, required: 3),
              specialTopics: TopicProgress(attended: scenario.$2, required: 1),
              completed: false,
            ),
          );
        await _pump(tester, repo, width: 320);
        await _open(tester, AppStrings.sectionBasic);
        final sheet = find.byType(SectionProgressSheet);
        Finder inSheet(Finder finder) =>
            find.descendant(of: sheet, matching: finder);
        expect(
          inSheet(find.text('${scenario.$1} von 3 besucht')),
          findsOneWidget,
        );
        await tester.ensureVisible(
          inSheet(find.text(AppStrings.sectionCompletionQuestion)),
        );
        await tester.tap(
          inSheet(find.text(AppStrings.sectionCompletionQuestion)),
        );
        await tester.pumpAndSettle();
        expect(
          inSheet(find.text(AppStrings.sectionTheoryDoneAnswer)),
          findsNothing,
        );
        if (scenario == (3, 1)) {
          expect(
            inSheet(find.text(AppStrings.sectionAwaitingCompletion)),
            findsOneWidget,
          );
        } else {
          expect(
            inSheet(find.textContaining('1 Spezialstoffunterricht offen')),
            findsOneWidget,
          );
        }
        final switchButton = inSheet(find.text('Spezialstoff ansehen →'));
        await tester.ensureVisible(switchButton);
        await tester.tap(switchButton);
        await tester.pumpAndSettle();
        expect(
          inSheet(find.text('${scenario.$2} von 1 besucht')),
          findsOneWidget,
        );
        final title = inSheet(find.text(AppStrings.sectionSpecial));
        await tester.ensureVisible(title);
        await tester.fling(title, const Offset(0, 400), 1200);
        await tester.pumpAndSettle();
        expect(sheet, findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    },
  );
}

Future<void> _pump(
  WidgetTester tester,
  FakeProgressRepository repo, {
  double width = 440,
}) async {
  tester.view.physicalSize = Size(width, 956);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await getIt.reset();
  getIt.registerFactory(
    () => TheoryProgressCubit(
      GetTheoryProgressUseCase(repo),
      config: const AppConfig(
        apiBaseUrl: 'http://localhost:8080',
        demoMode: false,
      ),
    ),
  );
  await tester.pumpWidget(const TheoryProgressApp());
  await tester.pump(AppMotion.minimumLoading);
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester, String title) async {
  final card = find.byWidgetPredicate(
    (widget) => widget is SectionCard && widget.title == title,
  );
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}
