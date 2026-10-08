import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'pressable.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius28),
        boxShadow: AppDimensions.heroShadows,
      ),
      child: Padding(
        padding: AppDimensions.errorPadding,
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.space22),
            ExcludeSemantics(
              child: Container(
                width: AppDimensions.errorHaloSize,
                height: AppDimensions.errorHaloSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.dangerTint,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: AppDimensions.errorIconSize,
                  height: AppDimensions.errorIconSize,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    AppStrings.errorMark,
                    style: AppText.errorMark,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space18),
            Semantics(
              header: true,
              child: Text(
                AppStrings.errorTitle,
                style: AppText.headline,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.space14),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.errorBodyMaxWidth,
              ),
              child: Text(
                message,
                style: AppText.errorBody,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            Pressable(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(AppDimensions.radius14),
              pressedScale: AppMotion.retryPressedScale,
              background: AppColors.ink,
              pressedBackground: AppColors.inkHover,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppDimensions.retryHeight,
                ),
                child: const Padding(
                  padding: AppDimensions.retryPadding,
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Text(
                      AppStrings.retry,
                      style: AppText.button,
                      textAlign: TextAlign.center,
                    ),
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
