import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/app_failure.dart';

abstract class UseCase<Result, Params> {
  const UseCase();

  Future<Either<AppFailure, Result>> call(Params params);
}

final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
