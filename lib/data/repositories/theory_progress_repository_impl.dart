import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/theory_progress.dart';
import '../../domain/repositories/theory_progress_repository.dart';
import '../datasources/theory_progress_remote_data_source.dart';

final class TheoryProgressRepositoryImpl implements TheoryProgressRepository {
  const TheoryProgressRepositoryImpl(this._source);
  final TheoryProgressRemoteDataSource _source;

  @override
  Future<Either<AppFailure, TheoryProgress>> getTheoryProgress({
    required String studentId,
  }) async {
    try {
      final model = await _source.getTheoryProgress(studentId);
      if (model.studentId != studentId) {
        return const Left(InvalidResponseFailure());
      }
      return Right(model.toEntity());
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404) {
        return Left(StudentNotFoundFailure(studentId: studentId));
      }
      if (error.type == DioExceptionType.badResponse && status != null) {
        return Left(ServerFailure(statusCode: status));
      }
      if (error.error is FormatException) {
        return const Left(InvalidResponseFailure());
      }
      return const Left(NetworkFailure());
    } on FormatException {
      return const Left(InvalidResponseFailure());
    } on TypeError {
      return const Left(InvalidResponseFailure());
    } on ArgumentError {
      return const Left(InvalidResponseFailure());
    }
  }
}
