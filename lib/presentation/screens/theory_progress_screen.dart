import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text.dart';

/// The screen shell; progress components are added in the subsequent UI tasks.
class TheoryProgressScreen extends StatelessWidget {
  const TheoryProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppDimensions.screenPadding,
          children: [
            Semantics(
              header: true,
              child: Text(AppStrings.heroLabel, style: AppText.headline),
            ),
          ],
        ),
      ),
    );
  }
}
