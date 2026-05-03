import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';
import 'widgets/test_series_scaffold.dart';
import 'test_instructions_screen.dart';

class MockTestListScreen extends StatelessWidget {
  final TestGroupModel categoryGroup;

  const MockTestListScreen({super.key, required this.categoryGroup});

  @override
  Widget build(BuildContext context) {
    final tests = categoryGroup.tests ?? [];

    return TestSeriesScaffold(
      title: categoryGroup.title,
      body: tests.isEmpty
          ? const Center(child: Text('No tests available in this category'))
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: tests.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final test = tests[index];
                  return _buildTestCard(context, test);
                },
              ),
            ),
    );
  }

  Widget _buildTestCard(BuildContext context, MockTestModel test) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // "New" Badge Ribbon
          if (test.isNew || true) // Defaulting to true for demo as per Figma
            Positioned(
              top: 5,
              right: -25,
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          // Alternatively, a simpler "New" badge as seen in Figma looks like a small red tag
          // Let's use a simpler one if the ribbon looks too big, but Image 3 shows a ribbon-like tag.
          // Image 3 shows a red tag that says "New" on the top right.
          Positioned(
            top: 0,
            right: 15,
            child: Container(
              width: 40,
              height: 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/new_badge_tag.png'), // Placeholder or I can draw it with CustomPainter
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  // Drawing a simple red tag with CSS-like shape if image missing
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.red,
                    child: const Text(
                      'New',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Let's stick to a clean implementation of the red tag
          Positioned(
            top: 8,
            right: 12,
            child: _buildNewTag(),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  test.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Marking Scheme : ', '(+${test.positiveMarks ?? 4}/-${test.negativeMarks ?? 1})'),
                _buildDetailRow('Total Marks : ', '${test.totalMarks ?? 400}'),
                _buildDetailRow('Total Duration : ', test.durationSeconds != null ? '${test.durationSeconds! ~/ 3600} hr ${(test.durationSeconds! % 3600) ~/ 60} min' : '1 hr 0 min'),
                _buildDetailRow('No. of Questions : ', '100'),
                _buildDetailRow('Last attempted date : ', test.lastAttemptDate ?? 'sun May 11 2025 | 22:41:35'),
                _buildDetailRow('No. of Attempt : ', '${test.attemptsCount ?? 16}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton('View Performance', const Color(0xFF234C7A), () {}),
                    const SizedBox(width: 10),
                    _buildButton('Reattempt', const Color(0xFF234C7A), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestInstructionsScreen(test: test),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          bottomLeft: Radius.circular(2),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'New',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          // Small triangle for ribbon effect can be added with CustomPaint or just simple tag
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
