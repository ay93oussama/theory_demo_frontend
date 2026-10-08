import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theory_demo_frontend/core/config/app_config.dart';
import 'package:theory_demo_frontend/core/errors/app_failure.dart';
import 'package:theory_demo_frontend/core/network/dio_client.dart';
import 'package:theory_demo_frontend/data/datasources/theory_progress_remote_data_source.dart';
import 'package:theory_demo_frontend/data/models/theory_progress_model.dart';
import 'package:theory_demo_frontend/data/repositories/theory_progress_repository_impl.dart';
import 'package:theory_demo_frontend/domain/entities/theory_progress.dart';

void main() {
  final json = <String, dynamic>{
    'studentId': '3',
    'studentName': 'Oussama',
    'licenseClass': 'B',
    'basicTopics': {'attended': 8, 'required': 10},
    'specialTopics': {'attended': 1, 'required': 4},
    'completed': true,
  };

  test(
    'handwritten models round-trip dynamic counts and preserve API completion',
    () {
      final model = TheoryProgressModel.fromJson(json);
      expect(model.toJson(), json);
      expect(model.toEntity().totalRequired, 14);
      expect(model.toEntity().basicTopics.isComplete, isFalse);
      expect(model.toEntity().completed, isTrue);
      expect(
        () => TheoryProgressModel.fromJson({...json, 'studentName': null}),
        throwsA(isA<TypeError>()),
      );
    },
  );

  test('Dio requests the endpoint and repository returns an entity', () async {
    final dio = createDio(const AppConfig(apiBaseUrl: 'http://localhost:8080'));
    addTearDown(dio.close);
    dio.httpClientAdapter = _Adapter((options) {
      expect(
        options.uri.toString(),
        'http://localhost:8080/api/students/3/theory-progress',
      );
      expect(options.receiveTimeout, const Duration(seconds: 10));
      return _response(json);
    });
    final repo = TheoryProgressRepositoryImpl(
      TheoryProgressRemoteDataSource(dio),
    );
    expect(
      await repo.getTheoryProgress(studentId: '3'),
      Right<AppFailure, TheoryProgress>(
        TheoryProgressModel.fromJson(json).toEntity(),
      ),
    );
  });

  test(
    'HTTP, transport, and invalid responses become plain Dart failures',
    () async {
      final cases = <(ResponseBody Function(RequestOptions), AppFailure)>[
        (
          (_) => _response({'message': "Student '3' not found"}, status: 404),
          const StudentNotFoundFailure(studentId: '3'),
        ),
        (
          (_) => _response({}, status: 500),
          const ServerFailure(statusCode: 500),
        ),
        (
          (options) => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          ),
          const NetworkFailure(),
        ),
        (
          (options) => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
          const NetworkFailure(),
        ),
        ((_) => _response({'studentId': '3'}), const InvalidResponseFailure()),
        (
          (_) => _response({
            ...json,
            'basicTopics': {'attended': '8', 'required': 10},
          }),
          const InvalidResponseFailure(),
        ),
        (
          (_) => _response({...json, 'studentId': '2'}),
          const InvalidResponseFailure(),
        ),
        (
          (_) => _response({
            ...json,
            'basicTopics': {'attended': -1, 'required': 12},
          }),
          const InvalidResponseFailure(),
        ),
        (
          (_) => _response({
            ...json,
            'specialTopics': {'attended': 0, 'required': 0},
          }),
          const InvalidResponseFailure(),
        ),
        (
          (_) => ResponseBody.fromString(
            '{bad json',
            200,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          ),
          const InvalidResponseFailure(),
        ),
      ];
      for (final (respond, expected) in cases) {
        final dio = createDio(
          const AppConfig(apiBaseUrl: 'http://localhost:8080'),
        );
        dio.httpClientAdapter = _Adapter(respond);
        final repo = TheoryProgressRepositoryImpl(
          TheoryProgressRemoteDataSource(dio),
        );
        expect(
          await repo.getTheoryProgress(studentId: '3'),
          Left<AppFailure, TheoryProgress>(expected),
        );
        dio.close();
      }
    },
  );
}

ResponseBody _response(Object body, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);
  final ResponseBody Function(RequestOptions) respond;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => respond(options);
  @override
  void close({bool force = false}) {}
}
