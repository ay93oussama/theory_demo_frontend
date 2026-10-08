import 'package:dartz/dartz.dart';

import '../../core/errors/app_failure.dart';
import '../entities/theory_progress.dart';

abstract interface class TheoryProgressRepository {
  Future<Either<AppFailure, TheoryProgress>> getTheoryProgress({
    required String studentId,
  });
}
