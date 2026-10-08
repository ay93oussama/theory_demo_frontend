import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'pressable.dart';
import 'section_segments.dart';
import 'section_status_chip.dart';

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
    this.onTap,
  }) : assert(requiredCount > 0),
       assert(filledCount >= 0 && filledCount <= requiredCount);

  final String title;
  final String attendedLabel;
  final String statusLabel;
  final int requiredCount;
  final int filledCount;
  final bool isComplete;
  final VoidCallback? onTap;

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
        Flexible(
          child: isComplete
              ? SectionStatusChip(label: statusLabel, isComplete: true)
              : AnimatedDefaultTextStyle(
                  duration: duration,
                  style: AppText.sectionStatus.copyWith(
                    color: AppColors.primaryInk,
                  ),
                  child: Text(statusLabel, textAlign: TextAlign.right),
                ),
        ),
        if (onTap != null && !isComplete) ...[
          const SizedBox(width: AppDimensions.space6),
          const Icon(
            Icons.chevron_right_rounded,
            size: AppDimensions.sectionChevronSize,
            color: AppColors.iconMuted,
          ),
        ],
      ],
    );

    return Semantics(
      label: AppStrings.sectionSemantics(title, attendedLabel, statusLabel),
      button: onTap != null,
      onTap: onTap,
      onTapHint: onTap == null ? null : AppStrings.sectionOpen,
      excludeSemantics: true,
      child: Pressable(
        borderRadius: BorderRadius.circular(AppDimensions.radius22),
        pressedScale: AppMotion.actionPressedScale,
        onTap: onTap,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              SectionSegments(
                requiredCount: requiredCount,
                filledCount: filledCount,
                isComplete: isComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
