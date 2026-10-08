import 'package:dio/dio.dart';

import '../models/theory_progress_model.dart';

final class TheoryProgressRemoteDataSource {
  const TheoryProgressRemoteDataSource(this._dio);
  final Dio _dio;

  Future<TheoryProgressModel> getTheoryProgress(String studentId) async {
    final response = await _dio.get<Object?>(
      '/api/students/${Uri.encodeComponent(studentId)}/theory-progress',
    );
    final json = response.data;
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object.');
    }
    return TheoryProgressModel.fromJson(json);
  }
}
