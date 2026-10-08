import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/app_failure.dart';
import '../../core/usecases/use_case.dart';
import '../entities/theory_progress.dart';
import '../repositories/theory_progress_repository.dart';

final class GetTheoryProgressUseCase
    extends UseCase<TheoryProgress, GetTheoryProgressParams> {
  const GetTheoryProgressUseCase(this._repository);

  final TheoryProgressRepository _repository;

  @override
  Future<Either<AppFailure, TheoryProgress>> call(
    GetTheoryProgressParams params,
  ) {
    return _repository.getTheoryProgress(studentId: params.studentId);
  }
}

final class GetTheoryProgressParams extends Equatable {
  const GetTheoryProgressParams({required this.studentId});

  final String studentId;

  @override
  List<Object> get props => [studentId];
}
