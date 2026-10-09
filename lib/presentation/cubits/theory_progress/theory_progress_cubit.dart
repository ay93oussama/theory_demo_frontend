import 'dart:async';

import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/demo_students.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/theme/app_motion.dart';
import '../../../domain/entities/theory_progress.dart';
import '../../../domain/entities/topic_progress.dart';
import '../../../domain/usecases/get_theory_progress_use_case.dart';
import 'theory_progress_state.dart';

final class TheoryProgressCubit extends Cubit<TheoryProgressState> {
  TheoryProgressCubit(
    this._getProgress, {
    required AppConfig config,
    DateTime Function()? now,
  }) : demoMode = config.demoMode,
       _now = now ?? DateTime.now,
       super(
         TheoryProgressLoadingState(
           studentId: config.studentId,
           studentName: AppStrings.studentFallback(config.studentId),
           licenseClass: AppConfig.defaultLicenseClass,
         ),
       );

  final GetTheoryProgressUseCase _getProgress;
  final bool demoMode;
  final DateTime Function() _now;
  final _names = <String, String>{};
  final _classes = <String, String>{};
  int _requestVersion = 0;
  Timer? _timestampTimer;
  Future<List<DemoStudent>>? _demoRequest;

  List<DemoStudent> get demoStudents =>
      List.unmodifiable([for (final id in DemoStudents.ids) _demoStudent(id)]);

  DemoStudent _demoStudent(String id) {
    final name = _names[id] ?? AppStrings.studentFallback(id);
    return DemoStudent(
      id: id,
      name: name,
      initial: name.characters.first.toUpperCase(),
    );
  }

  Future<void> refresh() => loadStudent(state.studentId);

  Future<void> loadStudent(String studentId) async {
    if (isClosed) return;
    final version = ++_requestVersion;
    _timestampTimer?.cancel();
    emit(
      TheoryProgressLoadingState(
        studentId: studentId,
        studentName: _names[studentId] ?? AppStrings.studentFallback(studentId),
        licenseClass: _classes[studentId] ?? AppConfig.defaultLicenseClass,
      ),
    );

    // Start both together: a slow request does not incur an extra loading delay.
    final (response, _) = await (
      _getProgress(
        GetTheoryProgressParams(studentId: studentId),
      ).then((result) => (result, _now())),
      Future<void>.delayed(AppMotion.minimumLoading),
    ).wait;
    if (isClosed || version != _requestVersion) return;
    final (result, fetchedAt) = response;
    result.fold<void>(
      (failure) => emit(
        TheoryProgressFailureState(
          studentId: studentId,
          studentName:
              _names[studentId] ?? AppStrings.studentFallback(studentId),
          licenseClass: _classes[studentId] ?? AppConfig.defaultLicenseClass,
          failure: failure,
          message: switch (failure) {
            StudentNotFoundFailure() => AppStrings.errorNotFound,
            NetworkFailure() => AppStrings.errorNetwork,
            ServerFailure() ||
            InvalidResponseFailure() => AppStrings.errorServer,
          },
        ),
      ),
      (progress) {
        _cacheIdentity(progress);
        emit(_loaded(progress, fetchedAt));
        _timestampTimer = Timer.periodic(
          AppMotion.timestampInterval,
          (_) => updateTimestamp(),
        );
      },
    );
  }

  void updateTimestamp() {
    if (isClosed) return;
    if (state case final TheoryProgressLoadedState loaded) {
      emit(_loaded(loaded.progress, loaded.fetchedAt));
    }
  }

  Future<List<DemoStudent>> loadDemoStudents() {
    if (!demoMode || isClosed) return Future.value(demoStudents);
    return _demoRequest ??= _loadMissingNames().whenComplete(
      () => _demoRequest = null,
    );
  }

  Future<List<DemoStudent>> _loadMissingNames() async {
    await Future.wait([
      for (final id in DemoStudents.ids.where((id) => !_names.containsKey(id)))
        _getProgress(GetTheoryProgressParams(studentId: id)).then((result) {
          if (isClosed) return;
          // A failed name lookup retains its selectable fallback and retries next time.
          result.fold<void>((_) {}, _cacheIdentity);
        }),
    ]);
    return demoStudents;
  }

  void _cacheIdentity(TheoryProgress progress) {
    final name = progress.studentName.trim();
    _names[progress.studentId] = name.isEmpty
        ? AppStrings.studentFallback(progress.studentId)
        : name;
    _classes[progress.studentId] = progress.licenseClass;
  }

  TheoryProgressLoadedState _loaded(
    TheoryProgress progress,
    DateTime fetchedAt,
  ) {
    final status = switch (progress.stage) {
      TheoryProgressStage.complete => AppStrings.pillComplete,
      TheoryProgressStage.notStarted => AppStrings.pillNotStarted,
      _ => AppStrings.pillInProgress,
    };
    final (headline, subline) = switch (progress.stage) {
      TheoryProgressStage.complete => (
        AppStrings.headlineDone,
        AppStrings.subDone(progress.totalRequired),
      ),
      TheoryProgressStage.notStarted => (
        AppStrings.headlineEmpty,
        AppStrings.subEmpty,
      ),
      TheoryProgressStage.basicComplete => (
        AppStrings.headlineSpecialLeft(progress.specialTopics.remaining),
        AppStrings.subBasicDone,
      ),
      TheoryProgressStage.specialComplete => (
        AppStrings.headlineBasicLeft(progress.basicTopics.remaining),
        AppStrings.subSpecialDone,
      ),
      TheoryProgressStage.inProgress => (
        AppStrings.headlineLessonsLeft(progress.remainingLessons),
        AppStrings.subBothLeft(
          progress.basicTopics.remaining,
          progress.specialTopics.remaining,
        ),
      ),
    };
    final minutes = _now().difference(fetchedAt).inMinutes;
    return TheoryProgressLoadedState(
      progress: progress,
      studentName: _names[progress.studentId]!,
      fetchedAt: fetchedAt,
      updatedLabel: AppStrings.updated(
        minutes <= 0 ? AppStrings.justNow : AppStrings.minutesAgo(minutes),
      ),
      display: (
        progressRatio: progress.progressRatio,
        isComplete: progress.completed,
        lessonsStatus: progress.theoryLessonsStatus,
        examStatus: progress.theoryExamStatus,
        status: status,
        headline: headline,
        subline: subline,
        count: progress.totalAttended.toString(),
        suffix: AppStrings.totalSuffix(progress.totalRequired),
        semantics: AppStrings.gaugeSemantics(
          progress.totalAttended,
          progress.totalRequired,
          status,
        ),
        basicSheet: _sectionSheet(progress, isBasic: true),
        specialSheet: _sectionSheet(progress, isBasic: false),
        lessonsMeta: progress.completed
            ? AppStrings.step1Done
            : AppStrings.step1Meta(
                progress.totalAttended,
                progress.totalRequired,
              ),
        examMeta: progress.completed
            ? AppStrings.nextReady
            : AppStrings.nextLocked,
      ),
    );
  }

  String _sectionStatus(TopicProgress topic) => switch (topic.status) {
    TopicProgressStatus.notStarted => AppStrings.pillNotStarted,
    TopicProgressStatus.inProgress => AppStrings.pillLeft(topic.remaining),
    TopicProgressStatus.complete => AppStrings.pillDone,
  };

  SectionSheetDisplay _sectionSheet(
    TheoryProgress progress, {
    required bool isBasic,
  }) {
    final topic = isBasic ? progress.basicTopics : progress.specialTopics;
    final other = isBasic ? progress.specialTopics : progress.basicTopics;
    final title = isBasic ? AppStrings.sectionBasic : AppStrings.sectionSpecial;
    final otherTitle = isBasic
        ? AppStrings.sectionSpecial
        : AppStrings.sectionBasic;
    final completionAnswer = progress.completed
        ? AppStrings.sectionTheoryDoneAnswer
        : progress.remainingLessons == 0
        ? AppStrings.sectionAwaitingCompletion
        : AppStrings.sectionCompletionAnswer(
            progress.basicTopics.remaining,
            progress.specialTopics.remaining,
          );
    return (
      title: title,
      attendedLabel: AppStrings.attendedOf(topic.attended, topic.required),
      statusLabel: _sectionStatus(topic),
      requiredCount: topic.required,
      filledCount: topic.filledSegments,
      isComplete: topic.isComplete,
      remainingAnswer: topic.isComplete
          ? '${AppStrings.sectionFinished(title)} ${other.remaining > 0 ? AppStrings.sectionOtherRemaining(otherTitle, other.remaining) : completionAnswer}'
          : AppStrings.sectionRemainingAnswer(
              topic.attended,
              topic.required,
              topic.remaining,
            ),
      completionAnswer: completionAnswer,
      otherSectionAction: AppStrings.sectionOtherAction(otherTitle),
    );
  }

  @override
  Future<void> close() {
    ++_requestVersion;
    _timestampTimer?.cancel();
    return super.close();
  }
}
