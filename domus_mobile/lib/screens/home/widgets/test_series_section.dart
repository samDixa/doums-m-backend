import 'package:flutter/material.dart';
import 'package:domus_mobile/screens/home/test_series/free_mock_screen.dart';
import 'package:domus_mobile/screens/home/test_series/paid_mock_screen.dart';

class TestSeriesSection extends StatelessWidget {
  const TestSeriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1B3B5F), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            'Test Series',
            style: TextStyle(
                color: Color(0xFF1B3B5F),
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: _buildTestButton(context, "Free Mock", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FreeMockScreen()),
                );
              })),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildTestButton(context, "Paid Mock", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaidMockScreen()),
                );
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(BuildContext context, String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B3B5F),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
