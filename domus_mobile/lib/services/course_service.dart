import '../api/dio_client.dart';
import '../models/course_model.dart';

class CourseService {
  final DioClient _dioClient;

  CourseService(this._dioClient);

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await _dioClient.get('/courses/');
      return (response as List).map((c) => CourseModel.fromJson(c)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CourseModel> getCourseDetail(int courseId) async {
    try {
      final response = await _dioClient.get('/courses/$courseId');
      return CourseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
