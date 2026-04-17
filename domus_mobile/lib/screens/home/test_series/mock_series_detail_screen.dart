import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';
import 'mock_test_list_screen.dart';

class MockSeriesDetailScreen extends StatelessWidget {
  final TestGroupModel seriesGroup;

  const MockSeriesDetailScreen({super.key, required this.seriesGroup});

  @override
  Widget build(BuildContext context) {
    final categories = seriesGroup.children ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF021B3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          seriesGroup.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No categories available'))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, TestGroupModel category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockTestListScreen(categoryGroup: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/domus/subject_mcq.png', // Default icon
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.logo_dev, size: 48, color: Colors.red),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This Section contains ${category.tests?.length ?? 0} papers.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
