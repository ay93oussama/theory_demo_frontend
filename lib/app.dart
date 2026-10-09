import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/cubits/theory_progress/theory_progress_cubit.dart';
import 'presentation/screens/theory_progress_screen.dart';

class TheoryProgressApp extends StatelessWidget {
  const TheoryProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocProvider(
        create: (_) => getIt<TheoryProgressCubit>()..refresh(),
        child: const TheoryProgressScreen(),
      ),
    );
  }
}
