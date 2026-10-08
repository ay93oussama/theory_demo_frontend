import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';

class SectionStatusChip extends StatelessWidget {
  const SectionStatusChip({
    super.key,
    required this.label,
    required this.isComplete,
    this.labelKey,
  });

  final String label;
  final bool isComplete;
  final Key? labelKey;

  @override
  Widget build(BuildContext context) => Container(
    padding: AppDimensions.sectionPillPadding,
    decoration: BoxDecoration(
      color: isComplete ? AppColors.successTint : AppColors.primaryTint,
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isComplete) ...[
          const Icon(
            Icons.check_rounded,
            size: AppDimensions.sectionDoneCheckSize,
            color: AppColors.successInk,
          ),
          const SizedBox(width: AppDimensions.space4),
        ],
        Flexible(
          child: Text(
            label,
            key: labelKey,
            style: AppText.sectionSheetStatus.copyWith(
              color: isComplete ? AppColors.successInk : AppColors.primaryInk,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
