import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';

class ClassBadge extends StatelessWidget {
  const ClassBadge({super.key, required this.licenseClass});

  final String licenseClass;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: AppStrings.classBadge(licenseClass),
      excludeSemantics: true,
      child: SizedBox.fromSize(
        size: AppDimensions.licenceSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius7),
            border: Border.all(
              color: AppColors.licenceBorder,
              width: AppDimensions.thinBorderWidth,
            ),
          ),
          child: Padding(
            padding: AppDimensions.licencePadding,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.licenceBlue,
                borderRadius: BorderRadius.circular(AppDimensions.radius5),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(licenseClass, style: AppText.licence),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
