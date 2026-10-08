import 'package:dio/dio.dart';

import '../config/app_config.dart';

Dio createDio(AppConfig config) => Dio(
  BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: AppConfig.requestTimeout,
    receiveTimeout: AppConfig.requestTimeout,
    sendTimeout: AppConfig.requestTimeout,
    headers: {'Accept': 'application/json'},
  ),
);
