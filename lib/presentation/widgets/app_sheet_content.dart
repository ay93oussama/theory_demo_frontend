import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';

/// Keeps the drag target and close action outside the scrollable sheet body.
class AppSheetContent extends StatelessWidget {
  const AppSheetContent({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Semantics(
    scopesRoute: true,
    namesRoute: true,
    label: title,
    explicitChildNodes: true,
    child: Padding(
      padding: AppDimensions.sheetPadding.copyWith(bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ExcludeSemantics(
              child: Container(
                width: AppDimensions.sheetHandleSize.width,
                height: AppDimensions.sheetHandleSize.height,
                decoration: BoxDecoration(
                  color: AppColors.handle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Padding(
            padding: AppDimensions.headerPadding,
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(title, style: AppText.sheetTitle),
                  ),
                ),
                const SizedBox(width: AppDimensions.space10),
                IconButton(
                  tooltip: AppStrings.close,
                  onPressed: () => Navigator.of(context).pop(),
                  constraints: const BoxConstraints.tightFor(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                  ),
                  padding: EdgeInsets.zero,
                  icon: Container(
                    width: AppDimensions.sheetCloseSize,
                    height: AppDimensions.sheetCloseSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.ink,
                      size: AppDimensions.sheetCloseIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    AppDimensions.sheetPadding.bottom +
                    MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
