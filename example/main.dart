// Explicit, debug-only visual fixtures. This entry point never calls the API.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theory_demo_frontend/app.dart';
import 'package:theory_demo_frontend/core/constants/app_strings.dart';
import 'package:theory_demo_frontend/core/theme/app_dimensions.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';
import 'package:theory_demo_frontend/domain/entities/topic_progress.dart';
import 'package:theory_demo_frontend/presentation/widgets/error_card.dart';
import 'package:theory_demo_frontend/presentation/widgets/gauge_card.dart';
import 'package:theory_demo_frontend/presentation/widgets/next_step_row.dart';
import 'package:theory_demo_frontend/presentation/widgets/progress_header.dart';
import 'package:theory_demo_frontend/presentation/widgets/section_card.dart';

void main() {
  if (!kDebugMode) {
    throw UnsupportedError('The component preview requires a debug build.');
  }
  runApp(const TheoryProgressApp(home: _ComponentPreview()));
}

class _ComponentPreview extends StatefulWidget {
  const _ComponentPreview();

  @override
  State<_ComponentPreview> createState() => _ComponentPreviewState();
}

class _ComponentPreviewState extends State<_ComponentPreview> {
  static const _scenario = String.fromEnvironment(
    'PREVIEW_SCENARIO',
    defaultValue: 'progress',
  );
  bool _showError = _scenario == 'error' || _scenario == 'not-found';

  late final TheoryProgress _progress = _fixture(_scenario);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      ProgressHeader(
        studentName: _progress.studentName,
        licenseClass: _progress.licenseClass,
      ),
      if (_showError)
        ErrorCard(
          message: _scenario == 'not-found'
              ? AppStrings.errorNotFound
              : AppStrings.errorNetwork,
          onRetry: () => setState(() => _showError = false),
        )
      else ...[
        _gauge(),
        _section(AppStrings.sectionBasic, _progress.basicTopics),
        _section(AppStrings.sectionSpecial, _progress.specialTopics),
        NextStepRow(isReady: _progress.completed),
      ],
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: AppDimensions.screenPadding,
          itemCount: children.length,
          itemBuilder: (_, index) => children[index],
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppDimensions.space16),
        ),
      ),
    );
  }

  // Fixture-only preparation. The application Cubit owns this in task 7.
  Widget _gauge() {
    final status = switch (_progress.stage) {
      TheoryProgressStage.complete => AppStrings.pillComplete,
      TheoryProgressStage.notStarted => AppStrings.pillNotStarted,
      _ => AppStrings.pillInProgress,
    };
    final (headline, subline) = switch (_progress.stage) {
      TheoryProgressStage.complete => (
        AppStrings.headlineDone,
        AppStrings.subDone(_progress.totalRequired),
      ),
      TheoryProgressStage.notStarted => (
        AppStrings.headlineEmpty,
        AppStrings.subEmpty,
      ),
      TheoryProgressStage.basicComplete => (
        AppStrings.headlineSpecialLeft(_progress.specialTopics.remaining),
        AppStrings.subBasicDone,
      ),
      TheoryProgressStage.specialComplete => (
        AppStrings.headlineBasicLeft(_progress.basicTopics.remaining),
        AppStrings.subSpecialDone,
      ),
      TheoryProgressStage.inProgress => (
        AppStrings.headlineLessonsLeft(_progress.remainingLessons),
        AppStrings.subBothLeft(
          _progress.basicTopics.remaining,
          _progress.specialTopics.remaining,
        ),
      ),
    };
    return GaugeCard(
      progress: _progress.progressRatio,
      isComplete: _progress.completed,
      totalLabel: _progress.totalAttended.toString(),
      totalSuffix: AppStrings.totalSuffix(_progress.totalRequired),
      statusLabel: status,
      headline: headline,
      subline: subline,
      semanticsLabel: AppStrings.gaugeSemantics(
        _progress.totalAttended,
        _progress.totalRequired,
        status,
      ),
    );
  }

  Widget _section(String title, TopicProgress progress) {
    return SectionCard(
      title: title,
      attendedLabel: AppStrings.attendedOf(
        progress.attended,
        progress.required,
      ),
      statusLabel: switch (progress.status) {
        TopicProgressStatus.notStarted => AppStrings.pillNotStarted,
        TopicProgressStatus.inProgress => AppStrings.pillLeft(
          progress.remaining,
        ),
        TopicProgressStatus.complete => AppStrings.pillDone,
      },
      requiredCount: progress.required,
      filledCount: progress.filledSegments,
      isComplete: progress.isComplete,
    );
  }
}

TheoryProgress _fixture(String scenario) {
  final (basic, special, completed) = switch (scenario) {
    'empty' => (0, 0, false),
    'partial' => (12, 1, false),
    'special-complete' => (8, 2, false),
    'complete' => (12, 2, true),
    _ => (8, 1, false),
  };
  return TheoryProgress(
    studentId: '1',
    studentName: 'Tom',
    licenseClass: 'B',
    basicTopics: TopicProgress(attended: basic, required: 12),
    specialTopics: TopicProgress(attended: special, required: 2),
    completed: completed,
  );
}
