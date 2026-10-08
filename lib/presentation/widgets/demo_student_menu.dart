import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text.dart';
import '../cubits/theory_progress/theory_progress_state.dart';

Future<String?> showDemoStudentMenu({
  required BuildContext context,
  required GlobalKey anchor,
  required List<DemoStudent> initialStudents,
  required Future<List<DemoStudent>> students,
  required String selectedId,
}) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final anchorBox = anchor.currentContext!.findRenderObject()! as RenderBox;
  var anchorPosition = anchorBox.localToGlobal(
    Offset(0, anchorBox.size.height + AppDimensions.space8),
    ancestor: overlay,
  );

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppStrings.dismissStudentMenu,
    barrierColor: AppColors.transparent,
    transitionDuration: reduceMotion ? AppMotion.none : AppMotion.studentMenu,
    pageBuilder: (menuContext, animation, secondaryAnimation) => LayoutBuilder(
      builder: (context, constraints) {
        // Re-anchor after a viewport change, while retaining a safe fallback
        // if the underlying screen has been removed during dismissal.
        final currentAnchor = anchor.currentContext?.findRenderObject();
        if (currentAnchor is RenderBox && currentAnchor.attached) {
          anchorPosition = currentAnchor.localToGlobal(
            Offset(0, currentAnchor.size.height + AppDimensions.space8),
            ancestor: overlay,
          );
        }
        final padding = MediaQuery.paddingOf(context);
        final leftEdge = padding.left + AppDimensions.space8;
        final rightEdge =
            constraints.maxWidth - padding.right - AppDimensions.space8;
        final bottomEdge =
            constraints.maxHeight - padding.bottom - AppDimensions.space8;
        final width = math.min(
          AppDimensions.studentMenuWidth,
          rightEdge - leftEdge,
        );
        final top = anchorPosition.dy.clamp(
          padding.top + AppDimensions.space8,
          math.max(
            padding.top + AppDimensions.space8,
            bottomEdge - AppDimensions.minTapTarget,
          ),
        );
        return Stack(
          children: [
            Positioned(
              left: anchorPosition.dx.clamp(leftEdge, rightEdge - width),
              top: top.toDouble(),
              width: width,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: bottomEdge - top),
                child: DemoStudentMenu(
                  initialStudents: initialStudents,
                  students: students,
                  selectedId: selectedId,
                  onSelected: (id) => Navigator.of(menuContext).pop(id),
                ),
              ),
            ),
          ],
        );
      },
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = animation.drive(CurveTween(curve: AppMotion.emphasized));
      return FadeTransition(opacity: curved, child: child);
    },
  );
}

class DemoStudentMenu extends StatelessWidget {
  const DemoStudentMenu({
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
    label: AppStrings.switchStudent,
    explicitChildNodes: true,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: AppDimensions.studentMenuShadows,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          side: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.thinBorderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: AppDimensions.studentMenuPadding,
          child: FutureBuilder<List<DemoStudent>>(
            future: students,
            initialData: initialStudents,
            builder: (context, snapshot) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: AppDimensions.studentMenuRowPadding,
                  child: Text(
                    AppStrings.switchStudent,
                    style: AppText.studentMenuLabel,
                  ),
                ),
                for (final student in snapshot.data ?? initialStudents)
                  if (student.id != selectedId)
                    _StudentMenuItem(student: student, onSelected: onSelected),
                if (snapshot.connectionState != ConnectionState.done)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: AppDimensions.studentMenuRowPadding,
                      child: const Text(
                        AppStrings.loadingStudentNames,
                        style: AppText.meta,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _StudentMenuItem extends StatelessWidget {
  const _StudentMenuItem({required this.student, required this.onSelected});

  final DemoStudent student;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: student.name,
    onTap: () => onSelected(student.id),
    excludeSemantics: true,
    child: InkWell(
      onTap: () => onSelected(student.id),
      excludeFromSemantics: true,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.studentMenuRowHeight,
        ),
        child: Padding(
          padding: AppDimensions.studentMenuRowPadding,
          child: Row(
            children: [
              Container(
                width: AppDimensions.studentMenuAvatarSize,
                height: AppDimensions.studentMenuAvatarSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  student.name.characters.first.toUpperCase(),
                  style: AppText.studentMenuInitial,
                  textScaler: TextScaler.noScaling,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Text(student.name, style: AppText.studentMenuName),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
