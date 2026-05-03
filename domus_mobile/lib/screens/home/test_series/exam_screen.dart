import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/mock_test_model.dart';
import '../../../models/question_model.dart';

class ExamScreen extends StatefulWidget {
  final MockTestModel test;

  const ExamScreen({super.key, required this.test});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _currentQuestionIndex = 0;
  int _totalSeconds = 3600; // 1 hour for demo
  int _questionSeconds = 4;
  Timer? _timer;
  Timer? _questionTimer;
  
  // Demo questions
  final List<QuestionModel> _questions = [
    const QuestionModel(
      id: 1,
      questionText: 'Preload measures ?',
      optionA: 'End Systolic volume',
      optionB: 'End diastolic volume',
      optionC: 'Peripheral resistance',
      optionD: 'Stroke volume',
    ),
    const QuestionModel(
      id: 2,
      questionText: 'What is the powerhouse of the cell?',
      optionA: 'Nucleus',
      optionB: 'Mitochondria',
      optionC: 'Ribosome',
      optionD: 'Endoplasmic Reticulum',
    ),
  ];

  int? _selectedOption;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        setState(() => _totalSeconds--);
      } else {
        timer.cancel();
      }
    });
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _questionSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')} : ${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Toolbar (Marks, Timer, etc.)
            _buildToolbar(),
            
            // Main Question Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    _buildQuestionHeader(currentQuestion),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOption(0, currentQuestion.optionA),
                            _buildOption(1, currentQuestion.optionB),
                            _buildOption(2, currentQuestion.optionC),
                            _buildOption(3, currentQuestion.optionD),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomControls(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.test.title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Font size buttons
          _buildToolButton('A+'),
          const SizedBox(width: 4),
          _buildToolButton('A-'),
          const SizedBox(width: 12),
          // Language dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: 'English',
              underline: const SizedBox(),
              items: ['English', 'Hindi'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
              onChanged: (v) {},
            ),
          ),
          const Spacer(),
          // Marks
          _buildMarkBox('+4', Colors.green),
          const SizedBox(width: 4),
          _buildMarkBox('-1', Colors.red.shade300),
          const SizedBox(width: 12),
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF638002),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2))],
            ),
            child: Text(
              _formatTime(_totalSeconds),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildMarkBox(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildQuestionHeader(QuestionModel q) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q${_currentQuestionIndex + 1}: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(q.questionText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              '${(_questionSeconds ~/ 60).toString().padLeft(2, '0')} : ${(_questionSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    bool isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF86AB4B), // Greenish background as per Figma
      child: Column(
        children: [
          Row(
            children: [
              _buildControlButton('< Back', Colors.grey.shade200, Colors.black),
              const SizedBox(width: 12),
              _buildControlButton('Next >', Colors.white, Colors.black),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildControlButton('SAVE & NEXT', Colors.greenAccent.shade700, Colors.white),
              const SizedBox(width: 12),
              _buildControlButton('CLEAR', Colors.red.shade700, Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildControlButton('MARK FOR REVIEW & NEXT', Colors.blue.shade700, Colors.white),
              const SizedBox(width: 12),
              _buildControlButton('SAVE & MARK FOR REVIEW', Colors.yellow.shade700, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.black45, width: 0.5),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}
