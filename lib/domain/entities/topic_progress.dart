import 'dart:math' as math;

import 'package:equatable/equatable.dart';

enum TopicProgressStatus { notStarted, inProgress, complete }

final class TopicProgress extends Equatable {
  TopicProgress({required this.attended, required this.required}) {
    if (attended < 0) {
      throw ArgumentError.value(attended, 'attended', 'Must be non-negative');
    }
    if (required <= 0) {
      throw ArgumentError.value(required, 'required', 'Must be positive');
    }
  }

  /// Raw attendance may exceed the requirement and is preserved for display.
  final int attended;
  final int required;

  bool get isComplete => attended >= required;
  int get remaining => math.max(required - attended, 0);
  int get filledSegments => math.min(attended, required);
  double get progressRatio => filledSegments / required;

  TopicProgressStatus get status {
    if (isComplete) return TopicProgressStatus.complete;
    if (attended == 0) return TopicProgressStatus.notStarted;
    return TopicProgressStatus.inProgress;
  }

  @override
  List<Object> get props => [attended, required];
}
