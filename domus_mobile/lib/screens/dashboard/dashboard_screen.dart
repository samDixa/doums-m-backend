import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/home_notifier.dart';
import '../../models/question_model.dart';
import '../../widgets/shimmer_loading.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Exam', 'Study', 'Revision', 'Community'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF021B3A), // Dark blue background for the top
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA), // Light grey background for content
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        _buildEducationBanner(size),
                        const SizedBox(height: 20),
                        _buildHeaderTitle(),
                        const SizedBox(height: 15),
                        _buildCategorySelector(),
                        const SizedBox(height: 20),
                        _buildFeatureGrid(),
                        const SizedBox(height: 25),
                        _buildQuestionOfTheDay(),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Search here...',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white70),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildAppBarIcon(Icons.shopping_basket, Colors.yellow[600]!),
          _buildAppBarIcon(Icons.notifications, Colors.orange[400]!, hasBadge: true),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, Color color, {bool hasBadge = false}) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 28),
          onPressed: () {},
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEducationBanner(Size size) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF031E44), Color(0xFF021B3A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.graduationCap, size: 50, color: Colors.white.withOpacity(0.3)),
                  const SizedBox(height: 10),
                  const Text(
                    'LEARNING • GOAL',
                    style: TextStyle(color: Colors.white70, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: Text(
                'EDUCATION',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Center(
      child: Text(
        'Domus Homoeopathica',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((cat) {
          bool isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(color: isSelected ? const Color(0xFF021B3A) : Colors.grey[400]!),
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF021B3A) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final List<Map<String, dynamic>> features = [
      {'name': 'NTET', 'icon': Icons.menu_book, 'color': Colors.red[100]},
      {'name': 'Entrance', 'icon': Icons.assignment, 'color': Colors.blue[100]},
      {'name': 'Subject Wise MCQ', 'icon': Icons.list_alt, 'color': Colors.green[100]},
      {'name': 'Medicos Corner', 'icon': Icons.help_outline, 'color': Colors.orange[100]},
      {'name': 'Paid Mock', 'icon': Icons.currency_rupee, 'color': Colors.purple[100]},
      {'name': 'Study Notes', 'icon': Icons.edit_document, 'color': Colors.pink[100]},
      {'name': 'HMM', 'icon': Icons.book, 'color': Colors.cyan[100]},
      {'name': 'Aphorism', 'icon': Icons.auto_stories, 'color': Colors.amber[100]},
      {'name': 'OP', 'icon': Icons.account_balance, 'color': Colors.brown[100]},
      {'name': 'Therapeutics', 'icon': Icons.medical_services_outlined, 'color': Colors.indigo[100]},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildGridIcon(features[index]['name'], features[index]['icon'], features[index]['color']);
      },
    );
  }

  Widget _buildGridIcon(String name, IconData icon, Color? color) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF021B3A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildQuestionOfTheDay() {
    final homeState = ref.watch(homeNotifierProvider);
    final mcq = homeState.mcqOfDay;

    if (homeState.isLoading || mcq == null) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF021B3A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CardListSkeleton(itemCount: 1),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF021B3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Question of the Day',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('MMMM d').format(DateTime.now()),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mcq.questionText,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
                ),
                const SizedBox(height: 20),
                _buildOptionButton('A', mcq.optionA, mcq, 0),
                _buildOptionButton('B', mcq.optionB, mcq, 1),
                _buildOptionButton('C', mcq.optionC, mcq, 2),
                _buildOptionButton('D', mcq.optionD, mcq, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String label, String text, QuestionModel mcq, int index) {
    final isAnswered = mcq.selectedOptionIndex != null;
    final isSelected = mcq.selectedOptionIndex == index;
    final isCorrect = mcq.correctOption?.toUpperCase() == label;
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    
    if (isAnswered) {
      if (isCorrect) {
        backgroundColor = const Color(0xFFD4EDDA); // Light green
        borderColor = Colors.green;
      } else if (isSelected) {
        backgroundColor = const Color(0xFFF8D7DA); // Light red
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () {
        if (!isAnswered) {
          ref.read(homeNotifierProvider.notifier).submitMCQVote(mcq.id, label, index);
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              '$label. ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            if (isAnswered && mcq.optionStats != null)
              Text(
                '${mcq.optionStats![label]?.toStringAsFixed(1) ?? '0'}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : (isSelected ? Colors.red : Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
