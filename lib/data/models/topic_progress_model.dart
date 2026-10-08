import '../../domain/entities/topic_progress.dart';

final class TopicProgressModel {
  const TopicProgressModel({required this.attended, required this.required});

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) {
    return TopicProgressModel(
      attended: json['attended'] as int,
      required: json['required'] as int,
    );
  }

  final int attended;
  final int required;

  Map<String, dynamic> toJson() => {'attended': attended, 'required': required};
  TopicProgress toEntity() =>
      TopicProgress(attended: attended, required: required);
}
