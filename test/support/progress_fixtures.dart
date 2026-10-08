import 'package:dartz/dartz.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/entities/topic_progress.dart';
import 'package:theory_demo_frontend/domain/repositories/theory_progress_repository.dart';

TheoryProgress progressFixture(String id, {bool? completed}) {
  final (name, basic, special, done) = switch (id) {
    '2' => ('Julian', 0, 0, false),
    '3' => ('Oussama', 12, 2, true),
    _ => ('Tom', 8, 1, false),
  };
  return TheoryProgress(
    studentId: id,
    studentName: name,
    licenseClass: 'B',
    basicTopics: TopicProgress(attended: basic, required: 12),
    specialTopics: TopicProgress(attended: special, required: 2),
    completed: completed ?? done,
  );
}

class FakeProgressRepository implements TheoryProgressRepository {
  final requests = <String>[];
  Future<Either<AppFailure, TheoryProgress>> Function(String)? handler;

  @override
  Future<Either<AppFailure, TheoryProgress>> getTheoryProgress({
    required String studentId,
  }) {
    requests.add(studentId);
    return handler?.call(studentId) ??
        Future.value(Right(progressFixture(studentId)));
  }
}
