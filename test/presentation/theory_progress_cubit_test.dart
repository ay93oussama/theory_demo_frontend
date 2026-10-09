import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/core/config/app_config.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/core/theme/app_motion.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/usecases/get_theory_progress_use_case.dart';
import 'package:theory_demo_frontend/presentation/cubits/theory_progress/theory_progress_cubit.dart';
import 'package:theory_demo_frontend/presentation/cubits/theory_progress/theory_progress_state.dart';

import '../support/progress_fixtures.dart';

void main() {
  testWidgets(
    'success waits 800 ms, prepares German copy, and ages the timestamp',
    (tester) async {
      final repo = FakeProgressRepository();
      var now = DateTime(2026, 10, 9, 12);
      final cubit = _cubit(repo, now: () => now);
      final future = cubit.refresh();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 799));
      expect(cubit.state, isA<TheoryProgressLoadingState>());
      await tester.pump(const Duration(milliseconds: 1));
      await future;
      final state = cubit.state as TheoryProgressLoadedState;
      expect(state.studentName, 'Tom');
      expect(state.display.basicSheet.attendedLabel, '8 von 12');
      expect(state.display.specialSheet.attendedLabel, '1 von 2');
      expect(state.display.progressRatio, 9 / 14);
      expect(state.display.isComplete, isFalse);
      expect(state.display.lessonsStatus, RoadStepStatus.current);
      expect(state.display.examStatus, RoadStepStatus.locked);
      expect(state.updatedLabel, contains('gerade eben'));
      now = now.add(const Duration(minutes: 5));
      await tester.pump(AppMotion.timestampInterval);
      expect(
        (cubit.state as TheoryProgressLoadedState).updatedLabel,
        contains('vor 5 Min.'),
      );
      expect(repo.requests, ['1']);
      await cubit.close();
    },
  );

  testWidgets(
    '404 and network errors have distinct copy; retry preserves the selected identity',
    (tester) async {
      final repo = FakeProgressRepository();
      final cubit = _cubit(repo);
      Future<void> finish(Future<void> request) async {
        await tester.pump(AppMotion.minimumLoading);
        await request;
      }

      await finish(cubit.loadStudent('3'));
      repo.handler = (id) async => Left(StudentNotFoundFailure(studentId: id));
      await finish(cubit.refresh());
      expect(
        (cubit.state as TheoryProgressFailureState).message,
        'Dieser Fahrschüler wurde nicht gefunden.',
      );
      expect(cubit.state.studentName, 'Oussama');
      repo.handler = (_) async => const Left(NetworkFailure());
      await finish(cubit.refresh());
      expect(
        (cubit.state as TheoryProgressFailureState).message,
        contains('Der Server ist nicht erreichbar'),
      );
      repo.handler = null;
      await finish(cubit.refresh());
      expect(
        (cubit.state as TheoryProgressLoadedState).display.headline,
        'Theorie erledigt ✓',
      );
      expect(repo.requests, ['3', '3', '3', '3']);
      await cubit.close();
    },
  );

  testWidgets(
    'slow and stale requests cannot overwrite a newer student or emit after close',
    (tester) async {
      final pending = <String, Completer<Either<AppFailure, TheoryProgress>>>{};
      final repo = FakeProgressRepository()
        ..handler = (id) => (pending[id] = Completer()).future;
      final cubit = _cubit(repo);
      final old = cubit.loadStudent('1');
      final latest = cubit.loadStudent('2');
      expect(cubit.state.studentName, 'Fahrschüler 2');
      await tester.pump(const Duration(milliseconds: 1200));
      pending['2']!.complete(Right(progressFixture('2')));
      await tester.pump();
      await latest;
      expect(
        cubit.state,
        isA<TheoryProgressLoadedState>(),
      ); // No additional 800 ms.
      pending['1']!.complete(Right(progressFixture('1')));
      await tester.pump();
      await old;
      expect(cubit.state.studentId, '2');
      final last = cubit.loadStudent('3');
      await cubit.close();
      pending['3']!.complete(Right(progressFixture('3')));
      await tester.pump(AppMotion.minimumLoading);
      await last;
      expect(cubit.state, isA<TheoryProgressLoadingState>());
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'selector caches API names and keeps failed lookups selectable',
    () async {
      final repo = FakeProgressRepository()
        ..handler = (id) async => id == '2'
            ? const Left(NetworkFailure())
            : Right(progressFixture(id));
      final cubit = _cubit(repo);
      final students = await cubit.loadDemoStudents();
      expect(students.map((student) => student.name), [
        'Tom',
        'Fahrschüler 2',
        'Oussama',
      ]);
      expect(cubit.state, isA<TheoryProgressLoadingState>());
      repo.requests.clear();
      repo.handler = null;
      expect((await cubit.loadDemoStudents())[1].name, 'Julian');
      expect(repo.requests, ['2']);
      await cubit.close();
    },
  );
}

TheoryProgressCubit _cubit(
  FakeProgressRepository repo, {
  DateTime Function()? now,
}) => TheoryProgressCubit(
  GetTheoryProgressUseCase(repo),
  config: const AppConfig(apiBaseUrl: 'http://localhost:8080', demoMode: true),
  now: now,
);
