import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppText {
  static const fontFamily = 'Schibsted Grotesk';

  static const count = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.92,
    height: 1,
    color: AppColors.ink,
  );
  static const studentName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -.52,
    color: AppColors.ink,
  );
  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -.22,
    color: AppColors.ink,
  );
  static const sheetTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w800,
    letterSpacing: -.21,
    color: AppColors.ink,
  );
  static const loaderTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );
  static const countSuffix = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );
  static const sectionCount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.surface,
  );
  static const greeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );
  static const errorBody = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );
  static const checklist = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
  static const rowTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const attended = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const toast = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );
  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );
  static const meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const sectionPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryInk,
  );
  static const statusPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const rpm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: .96,
    color: AppColors.textMuted,
  );
  static const refresh = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFaint,
  );
  static const licence = TextStyle(
    fontFamily: fontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: AppColors.surface,
  );
}
