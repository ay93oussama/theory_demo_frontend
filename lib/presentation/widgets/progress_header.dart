import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import 'class_badge.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.studentName,
    required this.licenseClass,
    this.onStudentTap,
    this.studentNameAnchor,
    this.studentMenuOpen = false,
  });

  final String studentName;
  final String licenseClass;
  final VoidCallback? onStudentTap;
  final GlobalKey? studentNameAnchor;
  final bool studentMenuOpen;

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
                key: studentNameAnchor,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              studentName,
                              style: AppText.studentName,
                            ),
                          ),
                          if (onStudentTap != null) ...[
                            const SizedBox(width: AppDimensions.space8),
                            AnimatedRotation(
                              turns: studentMenuOpen ? .5 : 0,
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? AppMotion.none
                                  : AppMotion.studentMenu,
                              curve: AppMotion.emphasized,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textMuted,
                                size: AppDimensions.space20,
                              ),
                            ),
                          ],
                        ],
                      ),
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
