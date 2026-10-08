import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'pressable.dart';

class NextStepRow extends StatelessWidget {
  const NextStepRow({super.key, required this.isReady, this.onTap});

  final bool isReady;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius22),
      pressedScale: AppMotion.actionPressedScale,
      child: CustomPaint(
        foregroundPainter: const _DashedBorderPainter(),
        child: Padding(
          padding: AppDimensions.nextStepPadding,
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.nextStepDotSize,
                  height: AppDimensions.nextStepDotSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isReady ? AppColors.success : AppColors.surface,
                    border: Border.all(
                      color: isReady
                          ? AppColors.transparent
                          : AppColors.borderStrong,
                      width: AppDimensions.borderWidth,
                    ),
                  ),
                  child: Text(
                    isReady
                        ? AppStrings.nextStepArrow
                        : AppStrings.nextStepNumber,
                    style: AppText.nextStepMark.copyWith(
                      color: isReady ? AppColors.surface : AppColors.iconMuted,
                    ),
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.nextTitle, style: AppText.rowTitle),
                    const SizedBox(height: AppDimensions.space1),
                    Text(
                      isReady ? AppStrings.nextReady : AppStrings.nextLocked,
                      style: AppText.meta,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.space14),
              const ExcludeSemantics(
                child: Text(AppStrings.chevron, style: AppText.chevron),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(AppDimensions.borderWidth / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(AppDimensions.radius22),
        ),
      );
    final paint = Paint()
      ..color = AppColors.borderStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.borderWidth;
    for (final metric in path.computeMetrics()) {
      for (
        var offset = 0.0;
        offset < metric.length;
        offset += AppDimensions.dashLength + AppDimensions.dashGap
      ) {
        canvas.drawPath(
          metric.extractPath(
            offset,
            math.min(offset + AppDimensions.dashLength, metric.length),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}
