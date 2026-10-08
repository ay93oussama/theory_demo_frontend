import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';

/// Uses Flutter's sheet drag handling with the handoff's curve and scrim timing.
Future<void> showAppModalSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) => Navigator.of(context).push<void>(
  _AppSheetRoute(
    builder: builder,
    reduceMotion: MediaQuery.disableAnimationsOf(context),
    themes: InheritedTheme.capture(
      from: context,
      to: Navigator.of(context).context,
    ),
  ),
);

class _AppSheetRoute extends PopupRoute<void> {
  _AppSheetRoute({
    required this.builder,
    required this.reduceMotion,
    required this.themes,
  });

  final WidgetBuilder builder;
  final bool reduceMotion;
  final CapturedThemes themes;

  @override
  Duration get transitionDuration =>
      reduceMotion ? AppMotion.none : AppMotion.sheet;
  @override
  Color get barrierColor => AppColors.sheetScrim;
  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => AppStrings.dismissSheet;
  @override
  Curve get barrierCurve => AppMotion.sheetScrimCurve;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => themes.wrap(_SheetTransition(route: this, controller: controller!));
}

class _SheetTransition extends StatefulWidget {
  const _SheetTransition({required this.route, required this.controller});

  final _AppSheetRoute route;
  final AnimationController controller;

  @override
  State<_SheetTransition> createState() => _SheetTransitionState();
}

class _SheetTransitionState extends State<_SheetTransition> {
  ParametricCurve<double> _curve = AppMotion.emphasized;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) => FractionalTranslation(
          translation: Offset(0, 1 - _curve.transform(widget.controller.value)),
          child: child,
        ),
        child: BottomSheet(
          animationController: widget.controller,
          onClosing: () {
            if (widget.route.isCurrent) Navigator.of(context).pop();
          },
          onDragStart: (_) => setState(() => _curve = AppMotion.linear),
          onDragEnd: (_, {bool? isClosing}) => setState(() {
            _curve = Split(
              widget.controller.value,
              endCurve: AppMotion.emphasized,
            );
          }),
          showDragHandle: false,
          constraints: const BoxConstraints(minWidth: double.infinity),
          clipBehavior: Clip.antiAlias,
          builder: widget.route.builder,
        ),
      ),
    ),
  );
}
