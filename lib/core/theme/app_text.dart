import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppText {
  static const fontFamily = 'Schibsted Grotesk';
  static const normalLineHeight = 1.2;

  static const nextStepMark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.iconMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const chevron = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 1,
    color: AppColors.iconMuted,
    letterSpacing: 0,
  );
  static const errorMark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.surface,
    letterSpacing: 0,
    height: normalLineHeight,
  );

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
    height: normalLineHeight,
  );
  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -.22,
    color: AppColors.ink,
    height: normalLineHeight,
  );
  static final gaugeHeadline = headline.copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w700,
    letterSpacing: -.5,
    height: 1.18,
  );
  static final gaugeLabel = label.copyWith(fontWeight: FontWeight.w500);
  static final gaugeBody = body.copyWith(fontSize: 14, height: 1.5);
  static final gaugeCountSuffix = countSuffix.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static final gaugeFootnote = meta.copyWith(
    color: AppColors.textMuted,
    height: 1.5,
  );
  static const sheetTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w800,
    letterSpacing: -.21,
    color: AppColors.ink,
    height: normalLineHeight,
  );
  static const loaderTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const countSuffix = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const sectionCount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static final sectionHeading = sectionTitle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -.1,
    height: 1.4,
  );
  static final sectionAttendance = sectionCount.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static final sectionVisited = attended.copyWith(fontSize: 13, height: 1.45);
  static final sectionStatus = sectionPill.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.surface,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const greeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );
  static const errorBody = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
    letterSpacing: 0,
  );
  static const checklist = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const rowTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const attended = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const toast = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const sectionPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryInk,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const statusPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const rpm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: .96,
    color: AppColors.textMuted,
    height: normalLineHeight,
  );
  static const refresh = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textFaint,
    letterSpacing: 0,
    height: normalLineHeight,
  );
  static const licence = TextStyle(
    fontFamily: fontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: AppColors.surface,
    letterSpacing: 0,
    height: normalLineHeight,
  );
}
