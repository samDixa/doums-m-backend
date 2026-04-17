import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/api_constants.dart';
import '../../home/qotd_screen.dart';
import '../../home/explain_screen.dart';
import '../../../models/home_category_model.dart';
import '../../../models/question_model.dart';
import '../../../viewmodels/home_notifier.dart';
import '../sub_category_detail_screen.dart';
import '../../../../widgets/shimmer_loading.dart';

class DomusHomoeopathicaSection extends ConsumerStatefulWidget {
  const DomusHomoeopathicaSection({super.key});

  @override
  ConsumerState<DomusHomoeopathicaSection> createState() =>
      _DomusHomoeopathicaSectionState();
}

class _DomusHomoeopathicaSectionState extends ConsumerState<DomusHomoeopathicaSection> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeNotifierProvider.notifier).fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    if (_selectedCategory == null && homeState.categories.isNotEmpty) {
      Future.microtask(() {
        if (mounted && _selectedCategory == null && homeState.categories.isNotEmpty) {
           setState(() {
             _selectedCategory = homeState.categories.first;
           });
        }
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildTitleInsideCard(),
          if (homeState.categories.isNotEmpty)
            _buildCategoryChipsList(homeState.categories),
          const SizedBox(height: 16),
          if (homeState.isLoading && homeState.categories.isEmpty)
            const GridSkeleton()
          else if (homeState.error != null && homeState.categories.isEmpty)
            _buildErrorState(context, homeState.error!)
          else
            _buildIconGridBody(context, _selectedCategory != null ? homeState.subCategories[_selectedCategory!.id] ?? [] : []),
          const SizedBox(height: 8),
          _buildQuestionOfTheDaySection(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            "Connection Error",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(homeNotifierProvider.notifier).fetchHomeData(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Retry Connection"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B3B5F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleInsideCard() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Domus Homoeopathica',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChipsList(List<CategoryModel> categories) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory?.id == cat.id;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat.title,
                  style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                  ref.read(homeNotifierProvider.notifier).fetchSubCategories(cat.id);
                }
              },
              selectedColor: const Color(0xFF1B3B5F),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF1B3B5F)
                        : Colors.grey.shade300),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconGridBody(BuildContext context, List<SubCategoryModel> items) {
    if (items.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No items available.")));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 0,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _handleNavigation(context, item),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B3B5F),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: item.icon.startsWith('http') 
                      ? Image.network(
                          item.icon,
                          width: 38,
                          height: 38,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.category, color: Colors.blueAccent, size: 32),
                        )
                      : Image.network(
                          '${ApiConstants.baseUrl}${item.icon}',
                          width: 38,
                          height: 38,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.category, color: Colors.blueAccent, size: 32),
                        ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, SubCategoryModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryDetailScreen(
          subCategoryId: item.id,
          title: item.title,
        ),
      ),
    );
  }

  Widget _buildQuestionOfTheDaySection(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final mcq = homeState.mcqOfDay;

    if (homeState.isLoading || mcq == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CardListSkeleton(itemCount: 1),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildQuestionCard(
        context: context,
        model: mcq,
      ),
    );
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required QuestionModel model,
  }) {
    final bool isAnswered = model.selectedOptionIndex != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF021B3A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Column(
              children: [
                const Text(
                  'Question of the Day',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMMM d').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.questionText,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.4),
                ),
                const SizedBox(height: 20),
                _buildOption(
                  label: 'A',
                  text: model.optionA,
                  isCorrect: model.correctOption?.toUpperCase() == 'A',
                  isSelected: model.selectedOptionIndex == 0,
                  percentage: model.optionStats?['A'] ?? 0,
                  isAnswered: isAnswered,
                  onTap: () {
                    if (!isAnswered) {
                      ref.read(homeNotifierProvider.notifier).submitMCQVote(model.id, 'A', 0);
                    }
                  },
                ),
                _buildOption(
                  label: 'B',
                  text: model.optionB,
                  isCorrect: model.correctOption?.toUpperCase() == 'B',
                  isSelected: model.selectedOptionIndex == 1,
                  percentage: model.optionStats?['B'] ?? 0,
                  isAnswered: isAnswered,
                  onTap: () {
                    if (!isAnswered) {
                      ref.read(homeNotifierProvider.notifier).submitMCQVote(model.id, 'B', 1);
                    }
                  },
                ),
                _buildOption(
                  label: 'C',
                  text: model.optionC,
                  isCorrect: model.correctOption?.toUpperCase() == 'C',
                  isSelected: model.selectedOptionIndex == 2,
                  percentage: model.optionStats?['C'] ?? 0,
                  isAnswered: isAnswered,
                  onTap: () {
                    if (!isAnswered) {
                      ref.read(homeNotifierProvider.notifier).submitMCQVote(model.id, 'C', 2);
                    }
                  },
                ),
                _buildOption(
                  label: 'D',
                  text: model.optionD,
                  isCorrect: model.correctOption?.toUpperCase() == 'D',
                  isSelected: model.selectedOptionIndex == 3,
                  percentage: model.optionStats?['D'] ?? 0,
                  isAnswered: isAnswered,
                  onTap: () {
                    if (!isAnswered) {
                      ref.read(homeNotifierProvider.notifier).submitMCQVote(model.id, 'D', 3);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: isAnswered
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExplainScreen(model: model),
                                  ),
                                );
                              }
                            : null,
                        child: Text('Explain',
                            style: TextStyle(
                                color: isAnswered ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: isAnswered
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QOTDScreen()),
                                );
                              }
                            : null,
                        child: Text('More',
                            style: TextStyle(
                                color: isAnswered ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required String text,
    required bool isCorrect,
    required bool isSelected,
    required double percentage,
    required bool isAnswered,
    required VoidCallback onTap,
  }) {
    Color backgroundColor = Colors.white;
    if (isAnswered) {
      if (isCorrect) {
        backgroundColor = const Color(0xFFD4EDDA);
      } else if (isSelected) {
        backgroundColor = const Color(0xFFF8D7DA);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
              color: isAnswered
                  ? (isCorrect
                      ? Colors.green
                      : (isSelected ? Colors.red : Colors.black26))
                  : Colors.black26,
              width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            if (isAnswered)
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? Colors.green
                      : (isSelected ? Colors.red : Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
