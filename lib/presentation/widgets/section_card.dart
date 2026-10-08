import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';

/// Renders section values already calculated by the domain/controller.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.attendedLabel,
    required this.statusLabel,
    required this.requiredCount,
    required this.filledCount,
    required this.isComplete,
  }) : assert(requiredCount > 0),
       assert(filledCount >= 0 && filledCount <= requiredCount);

  final String title;
  final String attendedLabel;
  final String statusLabel;
  final int requiredCount;
  final int filledCount;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? AppMotion.none
        : AppMotion.color;
    final textScaler = MediaQuery.textScalerOf(context);
    final stackHeader =
        textScaler.scale(AppText.sectionHeading.fontSize!) >
        AppText.sectionHeading.fontSize! * AppDimensions.stackTextScale;
    final heading = Text(title, style: AppText.sectionHeading);
    final status = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isComplete) ...[
          Container(
            width: textScaler.scale(AppDimensions.sectionDoneSize),
            height: textScaler.scale(AppDimensions.sectionDoneSize),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_rounded,
              size: textScaler.scale(AppDimensions.sectionDoneCheckSize),
              color: AppColors.surface,
            ),
          ),
          const SizedBox(width: AppDimensions.space6),
        ],
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: duration,
            style: AppText.sectionStatus.copyWith(
              color: isComplete ? AppColors.successInk : AppColors.primaryInk,
            ),
            child: Text(statusLabel, textAlign: TextAlign.right),
          ),
        ),
      ],
    );

    return Semantics(
      label: AppStrings.sectionSemantics(title, attendedLabel, statusLabel),
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: duration,
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
            if (stackHeader)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading,
                  const SizedBox(height: AppDimensions.space6),
                  Align(alignment: Alignment.centerRight, child: status),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: AppDimensions.space12),
                  Flexible(child: status),
                ],
              ),
            const SizedBox(height: AppDimensions.space6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: attendedLabel,
                    style: AppText.sectionAttendance,
                  ),
                  TextSpan(
                    text: AppStrings.attendedSuffix,
                    style: AppText.sectionVisited,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    requiredCount * AppDimensions.segmentMaxWidth +
                    (requiredCount - 1) * AppDimensions.segmentGap,
              ),
              child: Row(
                children: [
                  for (var index = 0; index < requiredCount; index++) ...[
                    if (index > 0)
                      const SizedBox(width: AppDimensions.segmentGap),
                    Expanded(
                      child: AnimatedContainer(
                        duration: duration,
                        height: AppDimensions.segmentHeight,
                        decoration: BoxDecoration(
                          color: index < filledCount
                              ? (isComplete
                                    ? AppColors.success
                                    : AppColors.primary)
                              : AppColors.track,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusPill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
