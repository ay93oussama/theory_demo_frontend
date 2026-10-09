import 'package:flutter/material.dart';
import 'package:theory_demo_frontend/core/theme/app_theme.dart';

/// Supplies the production theme to isolated widget tests.
class TestApp extends StatelessWidget {
  const TestApp({required this.home, super.key});

  final Widget home;

  @override
  Widget build(BuildContext context) =>
      MaterialApp(theme: AppTheme.light, home: home);
}
