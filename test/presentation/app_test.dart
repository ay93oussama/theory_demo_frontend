import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/config/app_config.dart';
import 'package:theory_demo_frontend/core/di/injection_container.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/usecases/get_theory_progress_use_case.dart';
import 'package:theory_demo_frontend/presentation/cubits/theory_progress/theory_progress_cubit.dart';
import 'package:theory_demo_frontend/presentation/widgets/book_exam_button.dart';
import 'package:theory_demo_frontend/presentation/widgets/demo_student_menu.dart';
import 'package:theory_demo_frontend/presentation/widgets/progress_header.dart';
import 'package:theory_demo_frontend/presentation/widgets/theory_progress_loading.dart';

import '../support/progress_fixtures.dart';

void main() {
  tearDown(() => getIt.reset());

  testWidgets('blank API names use a selectable fallback and safe initials', (
    tester,
  ) async {
    final repo = FakeProgressRepository()
      ..handler = (id) async {
        final progress = progressFixture(id);
        return Right(
          TheoryProgress(
            studentId: id,
            studentName: switch (id) {
              '1' => '',
              '2' => ' \n ',
              _ => '  👩🏽‍🚀 Ada  ',
            },
            licenseClass: progress.licenseClass,
            basicTopics: progress.basicTopics,
            specialTopics: progress.specialTopics,
            completed: progress.completed,
          ),
        );
      };
    await _pump(tester, repo);
    await _finishLoading(tester);
    expect(find.text('Fahrschüler 1'), findsOneWidget);
    await tester.tap(find.text('Fahrschüler 1'));
    await tester.pumpAndSettle();
    expect(find.text('Fahrschüler 2'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
    expect(find.text('👩🏽‍🚀 Ada'), findsOneWidget);
    expect(find.text('👩🏽‍🚀'), findsOneWidget);
    await tester.tap(find.text('Fahrschüler 2'));
    await _finishLoading(tester);
    expect(find.byType(DemoStudentMenu), findsNothing);
    expect(find.text('Fahrschüler 2'), findsOneWidget);
    expect(find.text('0 von 12 besucht'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'German live screen selects students, shows complete/zero states, and refreshes',
    (tester) async {
      final repo = FakeProgressRepository();
      await _pump(tester, repo);
      expect(find.text('Motor startet…'), findsOneWidget);
      await _finishLoading(tester);
      expect(find.text('8 von 12 besucht'), findsOneWidget);
      expect(find.text('1 von 2 besucht'), findsOneWidget);
      expect(find.byType(BookExamButton), findsNothing);

      await tester.tap(find.text('Tom'));
      await tester.pumpAndSettle();
      expect(find.text('Fahrschüler wechseln'), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      expect(
        find.descendant(
          of: find.byType(DemoStudentMenu),
          matching: find.text('Tom'),
        ),
        findsNothing,
      );
      await tester.tap(find.text('Oussama'));
      await _finishLoading(tester);
      expect(find.text('Theorie erledigt ✓'), findsOneWidget);
      expect(find.byType(BookExamButton), findsOneWidget);
      await tester.tap(find.text('Theorieprüfung buchen →'));
      await tester.pumpAndSettle();
      expect(
        find.text('Die Prüfungsbuchung ist nicht Teil dieses Prototyps'),
        findsOneWidget,
      );

      await tester.tap(find.text('Oussama'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Julian'));
      await _finishLoading(tester);
      expect(find.text('0 von 12 besucht'), findsOneWidget);
      expect(find.text('0 von 2 besucht'), findsOneWidget);
      expect(find.byType(BookExamButton), findsNothing);

      final before = repo.requests.length;
      final refresh = find.text(
        'Aktualisiert gerade eben · Tippen zum Aktualisieren',
      );
      await tester.ensureVisible(refresh);
      await tester.pumpAndSettle();
      await tester.tap(refresh);
      await tester.pump();
      expect(find.byType(TheoryProgressLoading), findsOneWidget);
      await _finishLoading(tester);
      expect(repo.requests.length, before + 1);
      await tester.fling(find.byType(ListView), const Offset(0, 1200), 1500);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, 350));
      await tester.pump(const Duration(milliseconds: 300));
      await _finishLoading(tester);
      expect(repo.requests.length, greaterThan(before + 1));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'not-found copy and retry recover without enabling demo selection',
    (tester) async {
      final repo = FakeProgressRepository()
        ..handler = (id) async => Left(StudentNotFoundFailure(studentId: id));
      await _pump(tester, repo, demoMode: false);
      await _finishLoading(tester);
      expect(
        find.text('Dieser Fahrschüler wurde nicht gefunden.'),
        findsOneWidget,
      );
      expect(find.text('Erneut versuchen'), findsOneWidget);
      repo.handler = null;
      await tester.tap(find.text('Erneut versuchen'));
      await _finishLoading(tester);
      expect(find.text('8 von 12 besucht'), findsOneWidget);
      await tester.tap(find.text('Tom'));
      await tester.pumpAndSettle();
      expect(find.byType(DemoStudentMenu), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
      expect(repo.requests, ['1', '1']);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'student popup is anchored and dismisses without changing student',
    (tester) async {
      final repo = FakeProgressRepository();
      await _pump(tester, repo);
      await _finishLoading(tester);
      await tester.tap(find.text('Tom'));
      await tester.pumpAndSettle();
      final menu = tester.getRect(find.byType(DemoStudentMenu));
      final header = tester.getRect(find.byType(ProgressHeader));
      expect(menu.top, closeTo(header.bottom + 8, .01));
      expect(menu.left, closeTo(header.left + 2, .01));
      expect(menu.width, 248);
      expect(
        tester
            .widget<ProgressHeader>(find.byType(ProgressHeader))
            .studentMenuOpen,
        isTrue,
      );
      final requests = repo.requests.length;
      await tester.tapAt(const Offset(420, 400));
      await tester.pumpAndSettle();
      expect(find.byType(DemoStudentMenu), findsNothing);
      expect(find.text('Tom'), findsOneWidget);
      expect(repo.requests.length, requests);
      expect(
        tester
            .widget<ProgressHeader>(find.byType(ProgressHeader))
            .studentMenuOpen,
        isFalse,
      );
      await tester.tap(find.text('Tom'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(DemoStudentMenu), findsNothing);
      expect(find.text('Tom'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'student popup keeps failed name lookups selectable at large text scale',
    (tester) async {
      final lookup = Completer<Either<AppFailure, TheoryProgress>>();
      final repo = FakeProgressRepository();
      await _pump(tester, repo);
      await _finishLoading(tester);
      repo.handler = (id) =>
          id == '2' ? lookup.future : Future.value(Right(progressFixture(id)));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pump();
      await tester.tap(find.text('Tom'));
      await tester.pumpAndSettle();
      expect(find.text('Namen werden geladen…'), findsOneWidget);
      expect(find.text('Fahrschüler 2'), findsOneWidget);
      lookup.complete(const Left(NetworkFailure()));
      await tester.pumpAndSettle();
      expect(find.text('Namen werden geladen…'), findsNothing);
      expect(find.text('Fahrschüler 2'), findsOneWidget);
      expect(find.text('Oussama'), findsOneWidget);
      expect(tester.takeException(), isNull);
      repo.handler = null;
      await tester.tap(find.text('Fahrschüler 2'));
      await _finishLoading(tester);
      expect(find.byType(DemoStudentMenu), findsNothing);
      expect(find.text('Julian'), findsOneWidget);
      expect(repo.requests.last, '2');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}

Future<void> _finishLoading(WidgetTester tester) async {
  await tester.pump(AppMotion.minimumLoading);
  await tester.pumpAndSettle();
}

Future<void> _pump(
  WidgetTester tester,
  FakeProgressRepository repo, {
  bool demoMode = true,
}) async {
  tester.view.physicalSize = const Size(440, 956);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.localeTestValue = const Locale('en', 'US');
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearLocaleTestValue);
  await getIt.reset();
  getIt.registerFactory(
    () => TheoryProgressCubit(
      GetTheoryProgressUseCase(repo),
      config: AppConfig(
        apiBaseUrl: 'http://localhost:8080',
        demoMode: demoMode,
      ),
    ),
  );
  await tester.pumpWidget(const TheoryProgressApp());
}
