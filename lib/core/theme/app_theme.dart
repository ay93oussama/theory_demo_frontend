import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_motion.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppText.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: AppColors.primaryInk,
      secondary: AppColors.success,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.successTint,
      onSecondaryContainer: AppColors.successInk,
      error: AppColors.danger,
      onError: AppColors.surface,
      errorContainer: AppColors.dangerTint,
      onErrorContainer: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainer: AppColors.background,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      shadow: AppColors.heroShadow,
      scrim: AppColors.sheetScrim,
      surfaceTint: AppColors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: AppText.count,
      headlineLarge: AppText.studentName,
      headlineMedium: AppText.headline,
      headlineSmall: AppText.sheetTitle,
      titleLarge: AppText.sectionCount,
      titleMedium: AppText.sectionTitle,
      titleSmall: AppText.rowTitle,
      bodyLarge: AppText.body,
      bodyMedium: AppText.attended,
      bodySmall: AppText.meta,
      labelLarge: AppText.button,
      labelMedium: AppText.sectionPill,
      labelSmall: AppText.statusPill,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radius22)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.pressed)
              ? AppColors.inkHover
              : AppColors.ink;
        }),
        foregroundColor: const WidgetStatePropertyAll(AppColors.surface),
        textStyle: const WidgetStatePropertyAll(AppText.button),
        minimumSize: const WidgetStatePropertyAll(
          Size(0, AppDimensions.retryHeight),
        ),
        padding: const WidgetStatePropertyAll(AppDimensions.retryPadding),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius14),
            ),
          ),
        ),
        animationDuration: AppMotion.color,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.background,
      modalBackgroundColor: AppColors.background,
      modalBarrierColor: AppColors.sheetScrim,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      modalElevation: 0,
      dragHandleColor: AppColors.handle,
      dragHandleSize: AppDimensions.sheetHandleSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius30),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      circularTrackColor: AppColors.spinnerTrack,
      linearTrackColor: AppColors.track,
    ),
  );
}
