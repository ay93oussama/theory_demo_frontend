import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/entities/topic_progress.dart';
import 'package:theory_demo_frontend/domain/repositories/theory_progress_repository.dart';
import 'package:theory_demo_frontend/domain/usecases/get_theory_progress_use_case.dart';

void main() {
  test(
    'forwards the student ID and returns the repository entity as Right',
    () async {
      final progress = TheoryProgress(
        studentId: '3',
        studentName: 'Oussama',
        licenseClass: 'B',
        basicTopics: TopicProgress(attended: 12, required: 12),
        specialTopics: TopicProgress(attended: 2, required: 2),
        completed: true,
      );
      final repository = _FakeRepository(Right(progress));
      final useCase = GetTheoryProgressUseCase(repository);

      final result = await useCase(
        const GetTheoryProgressParams(studentId: '3'),
      );

      expect(repository.requestedStudentId, '3');
      result.fold<void>(
        (_) => fail('Expected a successful result'),
        (entity) => expect(entity, same(progress)),
      );
    },
  );

  test(
    'preserves repository failures as Left for the caller to fold',
    () async {
      const failures = <AppFailure>[
        StudentNotFoundFailure(studentId: '999'),
        NetworkFailure(),
        ServerFailure(statusCode: 500),
        InvalidResponseFailure(),
      ];

      for (final failure in failures) {
        final repository = _FakeRepository(Left(failure));
        final useCase = GetTheoryProgressUseCase(repository);

        final result = await useCase(
          const GetTheoryProgressParams(studentId: '999'),
        );

        expect(repository.requestedStudentId, '999');
        result.fold<void>(
          (error) => expect(error, same(failure)),
          (_) => fail('Expected a failure result'),
        );
      }
    },
  );
}

class _FakeRepository implements TheoryProgressRepository {
  _FakeRepository(this.result);

  final Either<AppFailure, TheoryProgress> result;
  String? requestedStudentId;

  @override
  Future<Either<AppFailure, TheoryProgress>> getTheoryProgress({
    required String studentId,
  }) async {
    requestedStudentId = studentId;
    return result;
  }
}
