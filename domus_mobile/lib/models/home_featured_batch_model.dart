import 'course_model.dart';

class HomeFeaturedBatchModel {
  final int id;
  final int courseId;
  final int sequence;
  final bool isActive;
  final CourseModel? course;

  HomeFeaturedBatchModel({
    required this.id,
    required this.courseId,
    required this.sequence,
    required this.isActive,
    this.course,
  });

  factory HomeFeaturedBatchModel.fromJson(Map<String, dynamic> json) {
    return HomeFeaturedBatchModel(
      id: json['id'],
      courseId: json['course_id'],
      sequence: json['sequence'],
      isActive: json['is_active'] ?? true,
      course: json['course'] != null ? CourseModel.fromJson(json['course']) : null,
    );
  }
}
