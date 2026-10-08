import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/config/app_config.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/domain/usecases/get_theory_progress_use_case.dart';
import 'package:theory_demo_frontend/presentation/cubits/theory_progress/theory_progress_cubit.dart';
import 'package:theory_demo_frontend/presentation/widgets/book_exam_button.dart';
import 'package:theory_demo_frontend/presentation/widgets/theory_progress_loading.dart';

import '../support/progress_fixtures.dart';

void main() {
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
      expect(find.text('Fahrschüler auswählen'), findsOneWidget);
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
      expect(find.text('Fahrschüler auswählen'), findsNothing);
      expect(repo.requests, ['1', '1']);
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
  await tester.pumpWidget(
    TheoryProgressApp(
      createCubit: () => TheoryProgressCubit(
        GetTheoryProgressUseCase(repo),
        config: AppConfig(
          apiBaseUrl: 'http://localhost:8080',
          demoMode: demoMode,
        ),
      ),
    ),
  );
}
