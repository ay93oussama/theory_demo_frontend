import 'package:equatable/equatable.dart';

/// Expected failures shared across layers, without transport or UI dependencies.
sealed class AppFailure extends Equatable {
  const AppFailure();

  @override
  List<Object?> get props => [];
}

final class StudentNotFoundFailure extends AppFailure {
  const StudentNotFoundFailure({required this.studentId});

  final String studentId;

  @override
  List<Object?> get props => [studentId];
}

/// Includes unreachable hosts and request timeouts.
final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class ServerFailure extends AppFailure {
  const ServerFailure({required this.statusCode});

  final int statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class InvalidResponseFailure extends AppFailure {
  const InvalidResponseFailure();
}
