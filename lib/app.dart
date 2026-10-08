import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/theory_progress_screen.dart';

class TheoryProgressApp extends StatelessWidget {
  const TheoryProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const TheoryProgressScreen(),
    );
  }
}
