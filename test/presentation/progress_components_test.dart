import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/core/constants/app_strings.dart';
import 'package:theory_demo_frontend/core/theme/app_dimensions.dart';
import 'package:theory_demo_frontend/presentation/widgets/error_card.dart';
import 'package:theory_demo_frontend/presentation/widgets/next_step_row.dart';
import 'package:theory_demo_frontend/presentation/widgets/progress_header.dart';
import 'package:theory_demo_frontend/presentation/widgets/section_card.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('section cards show German progress and accessible counts', (
    tester,
  ) async {
    await _pump(tester, [
      SectionCard(
        title: AppStrings.sectionBasic,
        attendedLabel: AppStrings.attendedOf(8, 12),
        statusLabel: AppStrings.pillLeft(4),
        requiredCount: 12,
        filledCount: 8,
        isComplete: false,
      ),
      SectionCard(
        title: AppStrings.sectionSpecial,
        attendedLabel: AppStrings.attendedOf(1, 2),
        statusLabel: AppStrings.pillLeft(1),
        requiredCount: 2,
        filledCount: 1,
        isComplete: false,
      ),
    ]);

    expect(find.text('8 von 12 besucht'), findsOneWidget);
    expect(find.text('1 von 2 besucht'), findsOneWidget);
    expect(find.text('Alles besucht'), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
    expect(
      find.bySemanticsLabel('Grundstoff: 8 von 12 besucht. Noch 4'),
      findsOneWidget,
    );
  });

  testWidgets(
    'zero and done cards reflow on narrow screens at large text scale',
    (tester) async {
      await _pump(
        tester,
        [
          SectionCard(
            title: AppStrings.sectionBasic,
            attendedLabel: AppStrings.attendedOf(12, 12),
            statusLabel: AppStrings.pillDone,
            requiredCount: 12,
            filledCount: 12,
            isComplete: true,
          ),
          SectionCard(
            title: AppStrings.sectionSpecial,
            attendedLabel: AppStrings.attendedOf(0, 2),
            statusLabel: AppStrings.pillNotStarted,
            requiredCount: 2,
            filledCount: 0,
            isComplete: false,
          ),
        ],
        textScale: 2,
        width: 320,
      );

      expect(find.text('12 von 12 besucht'), findsOneWidget);
      expect(find.text('0 von 2 besucht'), findsOneWidget);
      expect(find.text('Alles besucht'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(
        find.bySemanticsLabel('Grundstoff: 12 von 12 besucht. Alles besucht'),
        findsOneWidget,
      );
      expect(find.text('Nicht begonnen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'student name taps invoke selection and badge has German semantics',
    (tester) async {
      var selections = 0;
      await _pump(tester, [
        ProgressHeader(
          studentName: 'Oussama',
          licenseClass: 'B',
          onStudentTap: () => selections++,
        ),
      ]);

      await tester.tap(find.text('Oussama'));
      await tester.pumpAndSettle();
      expect(selections, 1);
      expect(find.bySemanticsLabel('Klasse B'), findsOneWidget);
    },
  );

  testWidgets('not-found error displays its message and retry callback works', (
    tester,
  ) async {
    var retries = 0;
    await _pump(tester, [
      ErrorCard(message: AppStrings.errorNotFound, onRetry: () => retries++),
    ], textScale: 2);

    expect(
      find.text('Dieser Fahrschüler wurde nicht gefunden.'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(AppStrings.errorTitle), findsOneWidget);
    expect(find.bySemanticsLabel(AppStrings.errorNotFound), findsOneWidget);
    expect(find.bySemanticsLabel(AppStrings.retry), findsOneWidget);
    await tester.ensureVisible(find.text('Erneut versuchen'));
    await tester.tap(find.text('Erneut versuchen'));
    await tester.pumpAndSettle();
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('locked next step still allows opening the road sheet', (
    tester,
  ) async {
    var taps = 0;
    await _pump(tester, [NextStepRow(isReady: false, onTap: () => taps++)]);

    expect(
      find.text('Wird freigeschaltet, sobald die Theorie erledigt ist'),
      findsOneWidget,
    );
    await tester.tap(find.text('Als Nächstes: Theorieprüfung'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}

Future<void> _pump(
  WidgetTester tester,
  List<Widget> children, {
  double textScale = 1,
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    TestApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: ListView.separated(
            padding: AppDimensions.screenPadding,
            itemCount: children.length,
            itemBuilder: (_, index) => children[index],
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.space16),
          ),
        ),
      ),
    ),
  );
}
