import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';

// Provider for CourseService
final courseServiceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CourseService(dioClient);
});

// State for CourseNotifier
class CourseState {
  final List<CourseModel> courses;
  final Map<int, CourseModel> courseDetails;
  final bool isLoading;
  final String? error;

  CourseState({
    this.courses = const [],
    this.courseDetails = const {},
    this.isLoading = false,
    this.error,
  });

  CourseState copyWith({
    List<CourseModel>? courses,
    Map<int, CourseModel>? courseDetails,
    bool? isLoading,
    String? error,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      courseDetails: courseDetails ?? this.courseDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Notifier for Courses
class CourseNotifier extends StateNotifier<CourseState> {
  final CourseService _courseService;

  CourseNotifier(this._courseService) : super(CourseState());

  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final courses = await _courseService.getCourses();
      state = state.copyWith(courses: courses, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchCourseDetail(int courseId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final course = await _courseService.getCourseDetail(courseId);
      final newDetails = Map<int, CourseModel>.from(state.courseDetails);
      newDetails[courseId] = course;
      state = state.copyWith(courseDetails: newDetails, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// Provider for CourseNotifier
final courseNotifierProvider = StateNotifierProvider<CourseNotifier, CourseState>((ref) {
  final courseService = ref.watch(courseServiceProvider);
  return CourseNotifier(courseService);
});
