import 'package:flutter/material.dart';
import 'package:domus_mobile/models/mock_test_models.dart';

class PerformanceScreen extends StatelessWidget {
  final MockPerformance performance;

  const PerformanceScreen({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF021B3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Physics Mock Test',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPerformanceHeader(),
            _buildInfoCard(),
            _buildPercentageStatus(),
            _buildMarksSummary(),
            _buildLeaderboardHeader(),
            _buildLeaderboardTable(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: const [
                Icon(Icons.stars, color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dr.Ankit\'s Performance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF8BC34A)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF689F38),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: const Text(
              'Rank : 65',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          _buildInfoRow('Mock paper name', ': ${performance.paperName}'),
          _buildInfoRow('Attempt Number', ': ${performance.attemptNumber}'),
          _buildInfoRow('Questions Attempt', ': ${performance.questionsAttempt}'),
          _buildInfoRow('Total Marks', ': ${performance.totalMarks}'),
          _buildMarkingSchemeRow(),
          _buildInfoRow('Total time taken', ': ${performance.timeTaken}'),
          _buildInfoRow('Start Time', ': ${performance.startTime}'),
          _buildInfoRow('End Time', ': ${performance.endTime}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          Expanded(flex: 4, child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildMarkingSchemeRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text('Marking scheme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                const Text(': ', style: TextStyle(fontSize: 15)),
                _buildSchemeBadge('+4', Colors.green),
                const SizedBox(width: 4),
                _buildSchemeBadge('-1', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPercentageStatus() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.percent, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Text('Percentage Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8BC34A))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularIndicator('0%', 'Correct', Colors.green),
              _buildCircularIndicator('0%', 'Incorrect', Colors.red),
              _buildCircularIndicator('100%', 'Unanswered', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(String percent, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4),
          ),
          alignment: Alignment.center,
          child: Text(percent, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildMarksSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryBox('MARKS OBTAINED', '0 marks', const Color(0xFFE1BEE7), Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryBox('CORRECT', '0 marks', const Color(0xFFDCEDC8), Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSummaryBox('INCORRECT', '0 marks', const Color(0xFFFFCDD2), Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryBox('UNANSWERED', '400 marks', const Color(0xFFFFF9C4), Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.orange, size: 28),
          const SizedBox(width: 8),
          const Text('Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8BC34A))),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Column(
        children: [
          // Table Header
          Container(
            color: const Color(0xFF616161),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _buildTableCell('Rank', flex: 1, color: Colors.white),
                _buildTableCell('Name', flex: 3, color: Colors.white),
                _buildTableCell('Score', flex: 1, color: Colors.white),
              ],
            ),
          ),
          // User Row
          _buildTableRow('!!', 'Dr.Ankit\'s', '00', const Color(0xFFE1BEE7), isBold: true),
          // Rank 1
          _buildTableRow('1', 'Cody Fisher', '325', const Color(0xFFFFF9C4)),
          // Rank 2
          _buildTableRow('2', 'Albert Flores', '300', const Color(0xFFE0E0E0)),
          // Rank 3
          _buildTableRow('3', 'Robert Fox', '298', Colors.white),
          // Rank 4
          _buildTableRow('4', 'Darrell Steward', '292', const Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String rank, String name, String score, Color bgColor, {bool isBold = false}) {
    return Container(
      decoration: BoxDecoration(color: bgColor, border: const Border(top: BorderSide(color: Colors.black))),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(rank, flex: 1, isBold: isBold),
          _buildTableCell(name, flex: 3, isBold: isBold, textAlign: TextAlign.start),
          _buildTableCell(score, flex: 1, isBold: isBold),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {int flex = 1, Color? color, bool isBold = false, TextAlign textAlign = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
