import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';
import '../cubits/theory_progress/theory_progress_state.dart';

class DemoStudentSheet extends StatelessWidget {
  const DemoStudentSheet({
    required this.initialStudents,
    required this.students,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<DemoStudent> initialStudents;
  final Future<List<DemoStudent>> students;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Semantics(
    scopesRoute: true,
    namesRoute: true,
    label: AppStrings.selectStudent,
    explicitChildNodes: true,
    child: SingleChildScrollView(
      padding: AppDimensions.sheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppDimensions.sheetHandleSize.width,
              height: AppDimensions.sheetHandleSize.height,
              decoration: BoxDecoration(
                color: AppColors.handle,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  AppStrings.selectStudent,
                  style: AppText.sheetTitle,
                ),
              ),
              IconButton(
                tooltip: AppStrings.close,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  size: AppDimensions.sheetCloseIconSize,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          FutureBuilder<List<DemoStudent>>(
            future: students,
            initialData: initialStudents,
            builder: (context, snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final student in snapshot.data ?? initialStudents)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.space10,
                    ),
                    child: Semantics(
                      selected: student.id == selectedId,
                      button: true,
                      child: Material(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius14,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radius14,
                          ),
                          onTap: () => onSelected(student.id),
                          child: Padding(
                            padding: AppDimensions.sectionPadding,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: AppText.rowTitle,
                                      ),
                                      const SizedBox(
                                        height: AppDimensions.space4,
                                      ),
                                      Text(
                                        AppStrings.demoStudentId(student.id),
                                        style: AppText.meta,
                                      ),
                                    ],
                                  ),
                                ),
                                if (student.id == selectedId)
                                  const ExcludeSemantics(
                                    child: Icon(
                                      Icons.check,
                                      color: AppColors.success,
                                      size: AppDimensions.space20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (snapshot.connectionState != ConnectionState.done)
                  Semantics(
                    liveRegion: true,
                    child: const Text(
                      AppStrings.loadingStudentNames,
                      style: AppText.meta,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
