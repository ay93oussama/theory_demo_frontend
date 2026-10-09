import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/entities/topic_progress.dart';

void main() {
  final scenarios = [
    (
      name: 'no lessons',
      basic: 0,
      special: 0,
      completed: false,
      stage: TheoryProgressStage.notStarted,
      basicDone: false,
      specialDone: false,
      total: 0,
      remaining: 14,
    ),
    (
      name: 'in progress',
      basic: 8,
      special: 1,
      completed: false,
      stage: TheoryProgressStage.inProgress,
      basicDone: false,
      specialDone: false,
      total: 9,
      remaining: 5,
    ),
    (
      name: 'only basic complete',
      basic: 12,
      special: 1,
      completed: false,
      stage: TheoryProgressStage.basicComplete,
      basicDone: true,
      specialDone: false,
      total: 13,
      remaining: 1,
    ),
    (
      name: 'only special complete',
      basic: 8,
      special: 2,
      completed: false,
      stage: TheoryProgressStage.specialComplete,
      basicDone: false,
      specialDone: true,
      total: 10,
      remaining: 4,
    ),
    (
      name: 'theory complete',
      basic: 12,
      special: 2,
      completed: true,
      stage: TheoryProgressStage.complete,
      basicDone: true,
      specialDone: true,
      total: 14,
      remaining: 0,
    ),
  ];

  for (final scenario in scenarios) {
    test(scenario.name, () {
      final progress = _progress(
        basic: scenario.basic,
        special: scenario.special,
        completed: scenario.completed,
      );

      expect(progress.stage, scenario.stage);
      expect(progress.basicTopics.isComplete, scenario.basicDone);
      expect(progress.specialTopics.isComplete, scenario.specialDone);
      expect(progress.totalAttended, scenario.total);
      expect(progress.remainingLessons, scenario.remaining);
      expect(progress.progressRatio, closeTo(scenario.total / 14, 0.00001));
      expect(
        progress.theoryLessonsStatus,
        scenario.completed ? RoadStepStatus.done : RoadStepStatus.current,
      );
      expect(
        progress.theoryExamStatus,
        scenario.completed ? RoadStepStatus.current : RoadStepStatus.locked,
      );
    });
  }

  test(
    'API completion takes precedence over attendance in either direction',
    () {
      final open = _progress(basic: 12, special: 2);
      expect(open.stage, TheoryProgressStage.inProgress);
      expect(open.theoryExamStatus, RoadStepStatus.locked);

      final complete = _progress(basic: 8, special: 1, completed: true);
      expect(complete.stage, TheoryProgressStage.complete);
      expect(complete.theoryExamStatus, RoadStepStatus.current);
      expect(complete.basicTopics.isComplete, isFalse);
      expect(complete.specialTopics.isComplete, isFalse);
    },
  );

  test('requirements determine totals, remaining counts, and section fill', () {
    final progress = _progress(
      basic: 3,
      special: 1,
      basicRequired: 5,
      specialRequired: 3,
    );

    expect(progress.totalRequired, 8);
    expect(progress.remainingLessons, 4);
    expect(progress.progressRatio, .5);
    expect(progress.basicTopics.remaining, 2);
    expect(progress.basicTopics.filledSegments, 3);
    expect(progress.specialTopics.remaining, 2);
    expect(progress.specialTopics.status, TopicProgressStatus.inProgress);
  });

  test(
    'surplus preserves raw counts and cannot replace missing special lessons',
    () {
      final progress = _progress(basic: 20, special: 1);

      expect(progress.totalAttended, 21);
      expect(progress.basicTopics.attended, 20);
      expect(progress.basicTopics.filledSegments, 12);
      expect(progress.basicTopics.remaining, 0);
      expect(progress.basicTopics.status, TopicProgressStatus.complete);
      expect(progress.remainingLessons, 1);
      expect(progress.progressRatio, 1);
      expect(progress.stage, TheoryProgressStage.basicComplete);
      expect(progress.completed, isFalse);
    },
  );

  test('invalid section counts are rejected at runtime', () {
    for (final (attended, required) in [(-1, 2), (0, 0), (0, -1)]) {
      expect(
        () => TopicProgress(attended: attended, required: required),
        throwsArgumentError,
      );
    }
  });
}

TheoryProgress _progress({
  required int basic,
  required int special,
  bool completed = false,
  int basicRequired = 12,
  int specialRequired = 2,
}) {
  return TheoryProgress(
    studentId: '1',
    studentName: 'Tom',
    licenseClass: 'B',
    basicTopics: TopicProgress(attended: basic, required: basicRequired),
    specialTopics: TopicProgress(attended: special, required: specialRequired),
    completed: completed,
  );
}
