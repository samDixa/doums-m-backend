import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/course_model.dart';
import '../../viewmodels/course_notifier.dart';
import '../../widgets/lecture_card.dart';
import '../../widgets/shimmer_loading.dart';

class NTETScreen extends ConsumerStatefulWidget {
  const NTETScreen({super.key});

  @override
  ConsumerState<NTETScreen> createState() => _NTETScreenState();
}

class _NTETScreenState extends ConsumerState<NTETScreen> {
  int _selectedIndex = 0;
  int? _courseId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(courseNotifierProvider.notifier).fetchCourses();
      final courses = ref.read(courseNotifierProvider).courses;
      
      // Try to find course titled "NTET"
      final ntet = courses.firstWhere(
        (c) => c.title.toLowerCase() == 'ntet',
        orElse: () => courses.isNotEmpty ? courses.first : CourseModel(id: -1, title: '', isPaid: false, isActive: false),
      );

      if (ntet.id != -1) {
        setState(() => _courseId = ntet.id);
        await ref.read(courseNotifierProvider.notifier).fetchCourseDetail(ntet.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseNotifierProvider);
    final course = _courseId != null ? courseState.courseDetails[_courseId] : null;

    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'NTET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // White Content Area (Rounded Top)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Custom Box Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildTabButton('Lecture', 0),
                          const SizedBox(width: 10),
                          _buildTabButton('Notes', 1),
                          const SizedBox(width: 10),
                          _buildTabButton('MCQs', 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Content
                    Expanded(
                      child: courseState.isLoading && course == null
                          ? const ListSkeleton(itemCount: 4)
                          : course == null
                              ? const Center(child: Text('No Course Data Found'))
                              : _buildContent(course),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE3F2FD).withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF26466D) : Colors.black45,
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(CourseModel course) {
    switch (_selectedIndex) {
      case 0:
        return _buildLectureTab(course);
      case 1:
        return _buildNotesTab(course);
      case 2:
        return _buildMCQTab(course);
      default:
        return Container();
    }
  }

  Widget _buildLectureTab(CourseModel course) {
    // Flatten lessons from all modules
    final lectures = course.modules?.expand((m) => m.lessons.where((l) => l.lessonType == 'video')).toList() ?? [];

    if (lectures.isEmpty) {
      return const Center(child: Text('No Lectures Available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        final lesson = lectures[index];
        final isLocked = !lesson.isPreview;
        return Stack(
          children: [
            LectureCard(
              title: lesson.title,
              progress: 0.0,
              duration: lesson.durationSeconds != null 
                ? '${lesson.durationSeconds! ~/ 60}:${(lesson.durationSeconds! % 60).toString().padLeft(2, '0')}'
                : 'Free Content',
              onMorePressed: () {},
            ),
            if (isLocked)
              Positioned(
                right: 14,
                top: 30,
                child: Image.asset(
                  'assets/icons/domus/lock_yellow.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.lock, color: Colors.orange, size: 24),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotesTab(CourseModel course) {
    final notes = course.modules?.expand((m) => m.lessons.where((l) => l.lessonType == 'pdf')).toList() ?? [];

    if (notes.isEmpty) {
      return const Center(child: Text('No Notes Available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final lesson = notes[index];
        final isLocked = !lesson.isPreview;
        return Stack(
          children: [
            LectureCard(
              title: lesson.title,
              progress: 0.0,
              duration: 'PDF Document',
              onMorePressed: () {},
            ),
            if (isLocked)
              Positioned(
                right: 14,
                top: 30,
                child: Image.asset(
                  'assets/icons/domus/lock_yellow.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.lock, color: Colors.orange, size: 24),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMCQTab(CourseModel course) {
    final tests = course.tests ?? [];

    if (tests.isEmpty) {
      return const Center(child: Text('No Tests Available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        final isLocked = !test.isActive;
        return Stack(
          children: [
            LectureCard(
              title: test.title,
              progress: 0.0,
              duration: test.durationSeconds != null ? '${test.durationSeconds! ~/ 60} mins' : 'Practice',
              onMorePressed: () {},
            ),
            if (isLocked)
              Positioned(
                right: 14,
                top: 30,
                child: Image.asset(
                  'assets/icons/domus/lock_yellow.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.lock, color: Colors.orange, size: 24),
                ),
              ),
          ],
        );
      },
    );
  }
}
