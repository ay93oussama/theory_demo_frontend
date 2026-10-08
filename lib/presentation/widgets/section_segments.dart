import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';

class SectionSegments extends StatelessWidget {
  const SectionSegments({
    super.key,
    required this.requiredCount,
    required this.filledCount,
    required this.isComplete,
  }) : assert(requiredCount > 0),
       assert(filledCount >= 0 && filledCount <= requiredCount);

  final int requiredCount;
  final int filledCount;
  final bool isComplete;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth:
          requiredCount * AppDimensions.segmentMaxWidth +
          (requiredCount - 1) * AppDimensions.segmentGap,
    ),
    child: Row(
      children: [
        for (var index = 0; index < requiredCount; index++) ...[
          if (index > 0) const SizedBox(width: AppDimensions.segmentGap),
          Expanded(
            child: AnimatedContainer(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? AppMotion.none
                  : AppMotion.color,
              height: AppDimensions.segmentHeight,
              decoration: BoxDecoration(
                color: index < filledCount
                    ? (isComplete ? AppColors.success : AppColors.primary)
                    : AppColors.track,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
