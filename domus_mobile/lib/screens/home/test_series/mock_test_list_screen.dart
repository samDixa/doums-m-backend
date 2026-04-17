import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';

class MockTestListScreen extends StatelessWidget {
  final TestGroupModel categoryGroup;

  const MockTestListScreen({super.key, required this.categoryGroup});

  @override
  Widget build(BuildContext context) {
    final tests = categoryGroup.tests ?? [];

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
          categoryGroup.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: tests.isEmpty
          ? const Center(child: Text('No tests available in this category'))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListView.separated(
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
        border: Border.all(color: test.isPaid ? Colors.orange.shade700 : Colors.black, width: test.isPaid ? 2 : 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (test.isPaid)
            BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (test.isPaid)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)),
                ),
                child: const Text(
                  'PAID',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        test.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (test.isPaid)
                      Text(
                        '₹${test.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.orange.shade800,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBoldLabelDetail('Marking Scheme : ', '(+${test.positiveMarks ?? 4}/-${test.negativeMarks ?? 1})'),
                _buildBoldLabelDetail('Total Marks : ', test.totalMarks?.toString() ?? 'N/A'),
                _buildBoldLabelDetail('Total Duration : ', test.durationSeconds != null ? '${test.durationSeconds! ~/ 60} mins' : 'N/A'),
                _buildBoldLabelDetail('No. of Questions : ', 'N/A'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3B5F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(100, 36),
                      ),
                      child: const Text('View Performance', style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: test.isPaid ? Colors.orange.shade700 : const Color(0xFF1B3B5F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(100, 36),
                      ),
                      child: Text(test.isPaid ? 'Buy to Unlock' : 'Start Test', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoldLabelDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
