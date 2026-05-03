import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';
import 'widgets/test_series_scaffold.dart';
import 'exam_screen.dart';

class TestInstructionsScreen extends StatelessWidget {
  final MockTestModel test;

  const TestInstructionsScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return TestSeriesScaffold(
      title: test.title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            // Logo
            Image.asset(
              'assets/icons/domus/domus_logo_full.png', // Assuming this path exists
              height: 80,
              errorBuilder: (context, error, stackTrace) => const Column(
                children: [
                  Icon(Icons.school, size: 60, color: Color(0xFF021B3A)),
                  Text(
                    'DOMUS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF021B3A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'internet connection throughout the exam.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF234C7A)),
            ),
            const SizedBox(height: 24),
            _buildInstructionItem('Do not refresh or close the browser/tab during the exam session.'),
            _buildInstructionItem('Once an answer is submitted or time runs out, you may not be able to go back.'),
            _buildInstructionItem('Avoid switching tabs or opening other applications — it may lead to disqualification.'),
            _buildInstructionItem('The exam system may track your activity for security and fairness.'),
            _buildInstructionItem('Only use the allowed materials or tools if mentioned in the instructions.'),
            _buildInstructionItem('Keep your Student ID or Enrollment Number ready for verification if needed.'),
            _buildInstructionItem('Click on "Start Exam" only when you are'),
            _buildInstructionItem('fully prepared to begin.'),
            
            const SizedBox(height: 40),
            
            // OK Button
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamScreen(test: test),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF234C7A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF234C7A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF234C7A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
