import 'package:equatable/equatable.dart';

import 'topic_progress.dart';

enum TheoryProgressStage {
  notStarted,
  inProgress,
  basicComplete,
  specialComplete,
  complete,
}

enum RoadStepStatus { locked, current, done }

final class TheoryProgress extends Equatable {
  const TheoryProgress({
    required this.studentId,
    required this.studentName,
    required this.licenseClass,
    required this.basicTopics,
    required this.specialTopics,
    required this.completed,
  });

  final String studentId;
  final String studentName;
  final String licenseClass;
  final TopicProgress basicTopics;
  final TopicProgress specialTopics;

  /// The backend's authoritative overall status; never inferred from attendance.
  final bool completed;

  int get totalAttended => basicTopics.attended + specialTopics.attended;
  int get totalRequired => basicTopics.required + specialTopics.required;

  /// Surplus attendance in one category cannot satisfy the other category.
  int get remainingLessons => basicTopics.remaining + specialTopics.remaining;

  double get progressRatio => (totalAttended / totalRequired).clamp(0.0, 1.0);

  TheoryProgressStage get stage {
    if (completed) return TheoryProgressStage.complete;
    if (totalAttended == 0) return TheoryProgressStage.notStarted;
    if (basicTopics.isComplete && !specialTopics.isComplete) {
      return TheoryProgressStage.basicComplete;
    }
    if (specialTopics.isComplete && !basicTopics.isComplete) {
      return TheoryProgressStage.specialComplete;
    }
    return TheoryProgressStage.inProgress;
  }

  RoadStepStatus get theoryLessonsStatus =>
      completed ? RoadStepStatus.done : RoadStepStatus.current;

  RoadStepStatus get theoryExamStatus =>
      completed ? RoadStepStatus.current : RoadStepStatus.locked;

  @override
  List<Object> get props => [
    studentId,
    studentName,
    licenseClass,
    basicTopics,
    specialTopics,
    completed,
  ];
}
