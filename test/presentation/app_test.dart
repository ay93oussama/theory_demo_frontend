import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/app.dart';

void main() {
  testWidgets('starts with German copy even on an English device', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('en', 'US');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(const TheoryProgressApp());

    expect(find.text('Theorie-Fortschritt'), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
