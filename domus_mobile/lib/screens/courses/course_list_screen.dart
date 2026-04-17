import 'package:flutter/material.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => _buildCourseItem(index),
      ),
    );
  }

  Widget _buildCourseItem(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(width: 60, height: 60, color: Colors.blue[100], child: const Icon(Icons.book)),
        title: Text('Medical Specialty ${index + 1}'),
        subtitle: const Text('Comprehensive course for NEET PG'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
