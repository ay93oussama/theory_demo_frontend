import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppDimensions {
  static const space2 = 2.0;
  static const space4 = 4.0;
  static const space6 = 6.0;
  static const space10 = 10.0;
  static const space12 = 12.0;
  static const space14 = 14.0;
  static const space16 = 16.0;
  static const space18 = 18.0;
  static const space20 = 20.0;
  static const space22 = 22.0;

  static const radius5 = 5.0;
  static const radius7 = 7.0;
  static const radius12 = 12.0;
  static const radius14 = 14.0;
  static const radius16 = 16.0;
  static const radius22 = 22.0;
  static const radius28 = 28.0;
  static const radius30 = 30.0;
  static const radiusPill = 999.0;

  static const screenPadding = EdgeInsets.fromLTRB(20, 10, 20, 32);
  static const sectionPadding = EdgeInsets.all(16);
  static const gaugePadding = EdgeInsets.fromLTRB(14, 14, 14, 22);
  static const loaderPadding = EdgeInsets.fromLTRB(18, 18, 18, 22);
  static const errorPadding = EdgeInsets.fromLTRB(14, 14, 14, 28);
  static const sheetPadding = EdgeInsets.fromLTRB(20, 10, 20, 40);
  static const toastPadding = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 12,
  );
  static const retryPadding = EdgeInsets.symmetric(horizontal: 36);

  static const retryHeight = 52.0;
  static const bookingHeight = 54.0;
  static const minTapTarget = 48.0;
  static const borderWidth = 1.5;
  static const gaugeSize = Size(280, 158);
  static const engineSize = Size(240, 210);
  static const enginePanelHeight = 228.0;
  static const skeletonHeight = 100.0;
  static const sheetHandleSize = Size(40, 5);
  static const toastMaxWidth = 320.0;
  static const toastBottom = 40.0;
  static const toastRise = 12.0;

  static const heroShadows = [
    BoxShadow(
      color: AppColors.heroShadow,
      offset: Offset(0, 20),
      blurRadius: 40,
      spreadRadius: -28,
    ),
  ];
}
