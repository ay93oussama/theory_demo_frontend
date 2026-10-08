import 'package:flutter/foundation.dart';

final class AppConfig {
  const AppConfig({required this.apiBaseUrl, this.studentId = '1', this.demoMode = false});

  factory AppConfig.fromEnvironment() {
    const override = String.fromEnvironment('API_BASE_URL');
    final baseUrl = override.isNotEmpty
        ? override
        : defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080'
        : 'http://localhost:8080';
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || !uri.hasAuthority || !['http', 'https'].contains(uri.scheme) || uri.hasQuery || uri.hasFragment) {
      throw const FormatException('API_BASE_URL must be an HTTP(S) base URL.');
    }
    const studentId = String.fromEnvironment('STUDENT_ID', defaultValue: '1');
    if (studentId.trim().isEmpty) {
      throw const FormatException('STUDENT_ID must not be empty.');
    }
    return AppConfig(
      apiBaseUrl: baseUrl.replaceFirst(RegExp(r'/+$'), ''),
      studentId: studentId.trim(),
      demoMode: const bool.fromEnvironment('DEMO_MODE', defaultValue: kDebugMode),
    );
  }

  static const requestTimeout = Duration(seconds: 10);
  static const defaultLicenseClass = 'B';
  final String apiBaseUrl;
  final String studentId;
  final bool demoMode;
}
