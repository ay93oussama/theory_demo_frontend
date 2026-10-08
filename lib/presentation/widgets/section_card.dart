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
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.sectionTitle),
        const SizedBox(height: AppDimensions.space3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: attendedLabel, style: AppText.sectionCount),
              const TextSpan(
                text: AppStrings.attendedSuffix,
                style: AppText.attended,
              ),
            ],
          ),
        ),
      ],
    );
    final pill = AnimatedContainer(
      duration: duration,
      padding: AppDimensions.sectionPillPadding,
      decoration: BoxDecoration(
        color: isComplete ? AppColors.successTint : AppColors.primaryTint,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Text(
        statusLabel,
        style: AppText.sectionPill.copyWith(
          color: isComplete ? AppColors.successInk : AppColors.primaryInk,
        ),
      ),
    );
    final stackHeader =
        MediaQuery.textScalerOf(context).scale(AppText.sectionTitle.fontSize!) >
        AppText.sectionTitle.fontSize! * AppDimensions.stackTextScale;

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
            color: isComplete ? AppColors.successBorder : AppColors.border,
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
                  details,
                  const SizedBox(height: AppDimensions.space12),
                  pill,
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: details),
                  const SizedBox(width: AppDimensions.space12),
                  pill,
                ],
              ),
            const SizedBox(height: AppDimensions.space12),
            Row(
              children: [
                for (var index = 0; index < requiredCount; index++) ...[
                  if (index > 0) const SizedBox(width: AppDimensions.space4),
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
                          AppDimensions.radius5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
