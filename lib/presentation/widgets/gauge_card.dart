import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'progress_gauge.dart';

/// Renders display values prepared by the controller; owns no progress rules.
class GaugeCard extends StatelessWidget {
  const GaugeCard({
    required this.progress,
    required this.isComplete,
    required this.totalLabel,
    required this.totalSuffix,
    required this.statusLabel,
    required this.headline,
    required this.subline,
    required this.semanticsLabel,
    super.key,
  });

  final double progress;
  final bool isComplete;
  final String totalLabel;
  final String totalSuffix;
  final String statusLabel;
  final String headline;
  final String subline;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? AppMotion.none
        : AppMotion.color;
    final label = Text(AppStrings.heroLabel, style: AppText.gaugeLabel);
    final status = AnimatedDefaultTextStyle(
      duration: duration,
      style: AppText.statusPill.copyWith(
        color: isComplete ? AppColors.success : AppColors.primary,
      ),
      child: Text(statusLabel),
    );
    final stackHeader =
        MediaQuery.textScalerOf(context).scale(AppText.gaugeLabel.fontSize!) >
        AppText.gaugeLabel.fontSize! * AppDimensions.stackTextScale;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius28),
        boxShadow: AppDimensions.gaugeShadows,
      ),
      child: Padding(
        padding: AppDimensions.gaugePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The gauge's semantic summary includes this label and status.
            ExcludeSemantics(
              child: stackHeader
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label,
                        const SizedBox(height: AppDimensions.space6),
                        status,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: label),
                        const SizedBox(width: AppDimensions.space10),
                        status,
                      ],
                    ),
            ),
            const SizedBox(height: AppDimensions.space22),
            Semantics(
              header: true,
              child: AnimatedDefaultTextStyle(
                duration: duration,
                style: AppText.gaugeHeadline.copyWith(
                  color: isComplete ? AppColors.success : AppColors.ink,
                ),
                child: Text(headline),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(subline, style: AppText.gaugeBody),
            const SizedBox(height: AppDimensions.space24),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                container: true,
                label: semanticsLabel,
                excludeSemantics: true,
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ProgressGauge(
                        progress: progress,
                        isComplete: isComplete,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: totalLabel, style: AppText.count),
                          const WidgetSpan(
                            child: SizedBox(width: AppDimensions.space3),
                          ),
                          TextSpan(
                            text: totalSuffix,
                            style: AppText.gaugeCountSuffix,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            if (isComplete) ...[
              const SizedBox(height: AppDimensions.space12),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: AppDimensions.gaugeFootnotePadding,
                  child: Text(
                    AppStrings.gaugeCompleteNextStep,
                    style: AppText.gaugeFootnote,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
