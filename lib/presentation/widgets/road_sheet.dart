import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';
import '../../domain/entities/theory_progress.dart';
import 'app_sheet_content.dart';

class RoadSheet extends StatelessWidget {
  const RoadSheet({
    required this.lessonsStatus,
    required this.examStatus,
    required this.lessonsMeta,
    required this.examMeta,
    super.key,
  });

  final RoadStepStatus lessonsStatus;
  final RoadStepStatus examStatus;
  final String lessonsMeta;
  final String examMeta;

  @override
  Widget build(BuildContext context) => AppSheetContent(
    title: AppStrings.roadTitle,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.border,
            width: AppDimensions.borderWidth,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radius22),
        ),
        child: Padding(
          padding: AppDimensions.roadCardPadding,
          child: Column(
            children: [
              _RoadStep(
                number: 1,
                title: AppStrings.step1Title,
                meta: lessonsMeta,
                status: lessonsStatus,
              ),
              _RoadStep(
                number: 2,
                title: AppStrings.step2Title,
                meta: examMeta,
                status: examStatus,
              ),
              const _RoadStep(
                number: 3,
                title: AppStrings.step3Title,
                meta: AppStrings.step3Meta,
                status: RoadStepStatus.locked,
              ),
              const _RoadStep(
                number: 4,
                title: AppStrings.step4Title,
                meta: AppStrings.step4Meta,
                status: RoadStepStatus.locked,
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _RoadStep extends StatelessWidget {
  const _RoadStep({
    required this.number,
    required this.title,
    required this.meta,
    required this.status,
    this.isLast = false,
  });

  final int number;
  final String title;
  final String meta;
  final RoadStepStatus status;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, statusLabel) = switch (status) {
      RoadStepStatus.done => (
        AppColors.success,
        AppColors.surface,
        AppStrings.step1Done,
      ),
      RoadStepStatus.current => (
        AppColors.ink,
        AppColors.surface,
        AppStrings.roadCurrent,
      ),
      RoadStepStatus.locked => (
        AppColors.surface,
        AppColors.iconMuted,
        AppStrings.roadLocked,
      ),
    };
    return Semantics(
      container: true,
      label: AppStrings.roadStepSemantics(number, title, meta, statusLabel),
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: AppDimensions.roadDotSize,
                  height: AppDimensions.roadDotSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                    border: status == RoadStepStatus.locked
                        ? Border.all(
                            color: AppColors.borderStrong,
                            width: AppDimensions.borderWidth,
                          )
                        : null,
                  ),
                  child: Text(
                    status == RoadStepStatus.done
                        ? AppStrings.checkMark
                        : number.toString(),
                    style: AppText.roadDot.copyWith(color: foreground),
                    textScaler: TextScaler.noScaling,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: AppDimensions.roadConnectorWidth,
                      constraints: const BoxConstraints(
                        minHeight: AppDimensions.roadConnectorMinHeight,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: AppDimensions.space4,
                      ),
                      color: status == RoadStepStatus.done
                          ? AppColors.success
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppDimensions.space14),
            Expanded(
              child: Padding(
                padding: AppDimensions.roadTextPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.rowTitle.copyWith(
                        color: status == RoadStepStatus.locked
                            ? AppColors.iconMuted
                            : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space2),
                    Text(meta, style: AppText.meta),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
