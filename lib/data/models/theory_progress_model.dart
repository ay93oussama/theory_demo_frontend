import '../../domain/entities/theory_progress.dart';
import 'topic_progress_model.dart';

final class TheoryProgressModel {
  const TheoryProgressModel({
    required this.studentId,
    required this.studentName,
    required this.licenseClass,
    required this.basicTopics,
    required this.specialTopics,
    required this.completed,
  });

  factory TheoryProgressModel.fromJson(Map<String, dynamic> json) {
    return TheoryProgressModel(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      licenseClass: json['licenseClass'] as String,
      basicTopics: TopicProgressModel.fromJson(
        json['basicTopics'] as Map<String, dynamic>,
      ),
      specialTopics: TopicProgressModel.fromJson(
        json['specialTopics'] as Map<String, dynamic>,
      ),
      completed: json['completed'] as bool,
    );
  }

  final String studentId;
  final String studentName;
  final String licenseClass;
  final TopicProgressModel basicTopics;
  final TopicProgressModel specialTopics;
  final bool completed;

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'studentName': studentName,
    'licenseClass': licenseClass,
    'basicTopics': basicTopics.toJson(),
    'specialTopics': specialTopics.toJson(),
    'completed': completed,
  };

  TheoryProgress toEntity() => TheoryProgress(
    studentId: studentId,
    studentName: studentName,
    licenseClass: licenseClass,
    basicTopics: basicTopics.toEntity(),
    specialTopics: specialTopics.toEntity(),
    completed: completed,
  );
}
