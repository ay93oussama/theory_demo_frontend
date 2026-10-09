import 'package:equatable/equatable.dart';

import '../../../core/errors/app_failure.dart';
import '../../../domain/entities/theory_progress.dart';

sealed class TheoryProgressState extends Equatable {
  const TheoryProgressState({
    required this.studentId,
    required this.studentName,
    required this.licenseClass,
  });
  final String studentId;
  final String studentName;
  final String licenseClass;

  @override
  List<Object?> get props => [studentId, studentName, licenseClass];
}

final class TheoryProgressLoadingState extends TheoryProgressState {
  const TheoryProgressLoadingState({
    required super.studentId,
    required super.studentName,
    required super.licenseClass,
  });
}

final class TheoryProgressFailureState extends TheoryProgressState {
  const TheoryProgressFailureState({
    required super.studentId,
    required super.studentName,
    required super.licenseClass,
    required this.failure,
    required this.message,
  });
  final AppFailure failure;
  final String message;
  @override
  List<Object?> get props => [...super.props, failure, message];
}

/// Prepared copy and rendering values. Progress decisions belong to domain.
typedef SectionSheetDisplay = ({
  String title,
  String attendedLabel,
  String statusLabel,
  int requiredCount,
  int filledCount,
  bool isComplete,
  String remainingAnswer,
  String completionAnswer,
  String otherSectionAction,
});

typedef ProgressDisplay = ({
  double progressRatio,
  bool isComplete,
  RoadStepStatus lessonsStatus,
  RoadStepStatus examStatus,
  String status,
  String headline,
  String subline,
  String count,
  String suffix,
  String semantics,
  String lessonsMeta,
  String examMeta,
  SectionSheetDisplay basicSheet,
  SectionSheetDisplay specialSheet,
});

final class TheoryProgressLoadedState extends TheoryProgressState {
  TheoryProgressLoadedState({
    required this.progress,
    required this.display,
    required this.fetchedAt,
    required this.updatedLabel,
    required super.studentName,
  }) : super(
         studentId: progress.studentId,
         licenseClass: progress.licenseClass,
       );

  final TheoryProgress progress;
  final ProgressDisplay display;
  final DateTime fetchedAt;
  final String updatedLabel;

  @override
  List<Object?> get props => [
    ...super.props,
    progress,
    display,
    fetchedAt,
    updatedLabel,
  ];
}

final class DemoStudent extends Equatable {
  const DemoStudent({
    required this.id,
    required this.name,
    required this.initial,
  });
  final String id;
  final String name;
  final String initial;
  @override
  List<Object> get props => [id, name, initial];
}
