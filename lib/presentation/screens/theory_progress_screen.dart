import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import '../cubits/theory_progress/theory_progress_cubit.dart';
import '../cubits/theory_progress/theory_progress_state.dart';
import '../widgets/app_modal_sheet.dart';
import '../widgets/book_exam_button.dart';
import '../widgets/demo_student_menu.dart';
import '../widgets/error_card.dart';
import '../widgets/gauge_card.dart';
import '../widgets/next_step_row.dart';
import '../widgets/progress_header.dart';
import '../widgets/road_sheet.dart';
import '../widgets/section_card.dart';
import '../widgets/section_progress_sheet.dart';
import '../widgets/theory_progress_loading.dart';

class TheoryProgressScreen extends StatefulWidget {
  const TheoryProgressScreen({super.key});

  @override
  State<TheoryProgressScreen> createState() => _TheoryProgressScreenState();
}

class _TheoryProgressScreenState extends State<TheoryProgressScreen>
    with WidgetsBindingObserver {
  final _studentNameAnchor = GlobalKey();
  bool _studentMenuOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TheoryProgressCubit>().updateTimestamp();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: BlocBuilder<TheoryProgressCubit, TheoryProgressState>(
        builder: (context, state) {
          final cubit = context.read<TheoryProgressCubit>();
          return RefreshIndicator(
            semanticsLabel: AppStrings.refresh,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () => state is TheoryProgressLoadingState
                ? Future<void>.value()
                : cubit.refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppDimensions.screenPadding,
              children: [
                ProgressHeader(
                  studentNameAnchor: _studentNameAnchor,
                  studentMenuOpen: _studentMenuOpen,
                  studentName: state.studentName,
                  licenseClass: state.licenseClass,
                  onStudentTap: cubit.demoMode
                      ? () => _showStudents(cubit)
                      : null,
                ),
                const SizedBox(height: AppDimensions.space16),
                switch (state) {
                  TheoryProgressLoadingState() => const TheoryProgressLoading(),
                  TheoryProgressFailureState() => ErrorCard(
                    message: state.message,
                    onRetry: cubit.refresh,
                  ),
                  TheoryProgressLoadedState() => _LoadedProgress(
                    state: state,
                    onRefresh: cubit.refresh,
                  ),
                },
              ],
            ),
          );
        },
      ),
    ),
  );

  Future<void> _showStudents(TheoryProgressCubit cubit) async {
    if (_studentMenuOpen) return;
    setState(() => _studentMenuOpen = true);
    final selectedId = await showDemoStudentMenu(
      context: context,
      anchor: _studentNameAnchor,
      initialStudents: cubit.demoStudents,
      students: cubit.loadDemoStudents(),
      selectedId: cubit.state.studentId,
    );
    if (!mounted) return;
    setState(() => _studentMenuOpen = false);
    if (selectedId != null) await cubit.loadStudent(selectedId);
  }
}

class _LoadedProgress extends StatelessWidget {
  const _LoadedProgress({required this.state, required this.onRefresh});
  final TheoryProgressLoadedState state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final display = state.display;
    final children = <Widget>[
      GaugeCard(
        progress: progress.progressRatio,
        isComplete: progress.completed,
        totalLabel: display.count,
        totalSuffix: display.suffix,
        statusLabel: display.status,
        headline: display.headline,
        subline: display.subline,
        semanticsLabel: display.semantics,
      ),
      if (progress.completed) const BookExamButton(),
      SectionCard(
        title: AppStrings.sectionBasic,
        attendedLabel: display.basicCount,
        statusLabel: display.basicStatus,
        requiredCount: progress.basicTopics.required,
        filledCount: progress.basicTopics.filledSegments,
        isComplete: progress.basicTopics.isComplete,
        onTap: () => _showSection(context, initiallyBasic: true),
      ),
      SectionCard(
        title: AppStrings.sectionSpecial,
        attendedLabel: display.specialCount,
        statusLabel: display.specialStatus,
        requiredCount: progress.specialTopics.required,
        filledCount: progress.specialTopics.filledSegments,
        isComplete: progress.specialTopics.isComplete,
        onTap: () => _showSection(context, initiallyBasic: false),
      ),
      NextStepRow(
        isReady: progress.completed,
        onTap: () => showAppModalSheet(
          context: context,
          builder: (_) => RoadSheet(
            lessonsStatus: progress.theoryLessonsStatus,
            examStatus: progress.theoryExamStatus,
            lessonsMeta: display.lessonsMeta,
            examMeta: display.examMeta,
          ),
        ),
      ),
      Semantics(
        button: true,
        label: state.updatedLabel,
        onTap: onRefresh,
        excludeSemantics: true,
        child: InkWell(
          onTap: onRefresh,
          borderRadius: BorderRadius.circular(AppDimensions.radius7),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTapTarget,
            ),
            child: Center(
              child: Text(
                state.updatedLabel,
                style: AppText.refresh,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ];
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: MediaQuery.disableAnimationsOf(context)
          ? AppMotion.none
          : AppMotion.dataFade,
      curve: AppMotion.loadingCurve,
      builder: (_, value, child) => Opacity(opacity: value, child: child),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const SizedBox(height: AppDimensions.space16),
            Semantics(
              container: true,
              explicitChildNodes: true,
              child: children[index],
            ),
          ],
        ],
      ),
    );
  }

  void _showSection(BuildContext context, {required bool initiallyBasic}) {
    showAppModalSheet(
      context: context,
      builder: (_) => SectionProgressSheet(
        basic: state.display.basicSheet,
        special: state.display.specialSheet,
        initiallyBasic: initiallyBasic,
      ),
    );
  }
}
