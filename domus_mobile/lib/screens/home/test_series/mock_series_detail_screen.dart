import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';
import 'mock_test_list_screen.dart';
import 'widgets/test_series_scaffold.dart';

class MockSeriesDetailScreen extends StatelessWidget {
  final TestGroupModel seriesGroup;

  const MockSeriesDetailScreen({super.key, required this.seriesGroup});

  @override
  Widget build(BuildContext context) {
    final categories = seriesGroup.children ?? [];

    return TestSeriesScaffold(
      title: seriesGroup.title,
      body: categories.isEmpty
          ? const Center(child: Text('No categories available'))
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/icons/domus/subject_mcq.png', // Default icon
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book_outlined, size: 32, color: Colors.blueGrey),
                ),
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
                      letterSpacing: -0.2,
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
