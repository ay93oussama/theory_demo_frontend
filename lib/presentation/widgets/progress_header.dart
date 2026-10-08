import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';
import 'class_badge.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.studentName,
    required this.licenseClass,
    this.onStudentTap,
  });

  final String studentName;
  final String licenseClass;
  final VoidCallback? onStudentTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.headerPadding,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              label: AppStrings.studentGreeting(studentName),
              button: onStudentTap != null,
              hint: onStudentTap != null ? AppStrings.switchStudent : null,
              onTap: onStudentTap,
              excludeSemantics: true,
              child: InkWell(
                onTap: onStudentTap,
                excludeFromSemantics: true,
                borderRadius: BorderRadius.circular(AppDimensions.radius7),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppDimensions.minTapTarget,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.greeting, style: AppText.greeting),
                      const SizedBox(height: AppDimensions.space2),
                      Text(studentName, style: AppText.studentName),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          ClassBadge(licenseClass: licenseClass),
        ],
      ),
    );
  }
}
