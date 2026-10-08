import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import '../cubits/theory_progress/theory_progress_state.dart';
import 'pressable.dart';
import 'section_segments.dart';
import 'section_status_chip.dart';

/// Attendance and answers are prepared by Cubit; disclosure state stays local.
class SectionProgressSheet extends StatefulWidget {
  const SectionProgressSheet({
    super.key,
    required this.basic,
    required this.special,
    required this.initiallyBasic,
  });

  final SectionSheetDisplay basic;
  final SectionSheetDisplay special;
  final bool initiallyBasic;

  @override
  State<SectionProgressSheet> createState() => _SectionProgressSheetState();
}

class _SectionProgressSheetState extends State<SectionProgressSheet> {
  late bool _showBasic = widget.initiallyBasic;
  int? _expandedQuestion = 0;

  @override
  Widget build(BuildContext context) {
    final display = _showBasic ? widget.basic : widget.special;
    final questions = [
      (AppStrings.sectionRemainingQuestion, display.remainingAnswer),
      (AppStrings.sectionTimetableQuestion, AppStrings.sectionTimetableAnswer),
      (AppStrings.sectionCompletionQuestion, display.completionAnswer),
    ];
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: display.title,
      explicitChildNodes: true,
      child: SingleChildScrollView(
        padding: AppDimensions.sheetPadding.copyWith(
          bottom:
              AppDimensions.sheetPadding.bottom +
              MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ExcludeSemantics(
                child: Container(
                  width: AppDimensions.sheetHandleSize.width,
                  height: AppDimensions.sheetHandleSize.height,
                  decoration: BoxDecoration(
                    color: AppColors.handle,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Padding(
              padding: AppDimensions.headerPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(display.title, style: AppText.sheetTitle),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space10),
                  IconButton(
                    tooltip: AppStrings.close,
                    onPressed: () => Navigator.of(context).pop(),
                    constraints: const BoxConstraints.tightFor(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                    ),
                    padding: EdgeInsets.zero,
                    icon: Container(
                      width: AppDimensions.sheetCloseSize,
                      height: AppDimensions.sheetCloseSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.ink,
                        size: AppDimensions.sheetCloseIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            _ProgressSummary(display: display),
            const SizedBox(height: AppDimensions.space16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius22),
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderWidth,
                ),
              ),
              child: Padding(
                padding: AppDimensions.sectionQuestionsPadding,
                child: Column(
                  children: [
                    for (var index = 0; index < questions.length; index++) ...[
                      if (index > 0)
                        const Divider(
                          height: AppDimensions.thinBorderWidth,
                          thickness: AppDimensions.thinBorderWidth,
                          color: AppColors.border,
                        ),
                      _Question(
                        question: questions[index].$1,
                        answer: questions[index].$2,
                        expanded: _expandedQuestion == index,
                        onTap: () => setState(() {
                          _expandedQuestion = _expandedQuestion == index
                              ? null
                              : index;
                        }),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Pressable(
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
              pressedScale: AppMotion.actionPressedScale,
              background: AppColors.ink,
              pressedBackground: AppColors.inkHover,
              onTap: () => setState(() {
                _showBasic = !_showBasic;
                _expandedQuestion = 0;
              }),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppDimensions.retryHeight,
                ),
                child: Padding(
                  padding: AppDimensions.nextStepPadding,
                  child: Text(
                    display.otherSectionAction,
                    style: AppText.button,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.display});
  final SectionSheetDisplay display;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppStrings.sectionSemantics(
      display.title,
      display.attendedLabel,
      display.statusLabel,
    ),
    excludeSemantics: true,
    child: Container(
      key: const ValueKey('section-sheet-summary'),
      padding: AppDimensions.sectionPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius22),
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  AppStrings.sectionProgress,
                  style: AppText.sectionTitle,
                ),
              ),
              const SizedBox(width: AppDimensions.space10),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SectionStatusChip(
                    key: const ValueKey('section-sheet-chip'),
                    labelKey: const ValueKey('section-sheet-status'),
                    label: display.statusLabel,
                    isComplete: display.isComplete,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: display.attendedLabel,
                  style: AppText.sectionCount,
                ),
                TextSpan(
                  text: AppStrings.attendedSuffix,
                  style: AppText.sectionVisited,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          SectionSegments(
            requiredCount: display.requiredCount,
            filledCount: display.filledCount,
            isComplete: display.isComplete,
          ),
        ],
      ),
    ),
  );
}

class _Question extends StatelessWidget {
  const _Question({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        button: true,
        expanded: expanded,
        label: question,
        onTap: onTap,
        excludeSemantics: true,
        child: Pressable(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          pressedScale: AppMotion.actionPressedScale,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.minTapTarget,
            ),
            child: Padding(
              padding: AppDimensions.sectionQuestionPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(question, style: AppText.sectionSheetQuestion),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: AppDimensions.sectionChevronSize,
                    color: AppColors.ink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      MediaQuery.disableAnimationsOf(context)
          ? _answer
          : AnimatedSize(
              alignment: Alignment.topCenter,
              duration: AppMotion.disclosure,
              curve: AppMotion.emphasized,
              child: _answer,
            ),
    ],
  );
  Widget get _answer => expanded
      ? Padding(
          padding: AppDimensions.sectionAnswerPadding,
          child: Text(answer, style: AppText.sectionSheetAnswer),
        )
      : const SizedBox.shrink();
}
