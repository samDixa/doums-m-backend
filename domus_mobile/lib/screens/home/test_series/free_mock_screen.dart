import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/mock_test_model.dart';
import '../../../viewmodels/mock_test_notifier.dart';
import 'mock_series_detail_screen.dart';
import '../../../widgets/shimmer_loading.dart';

class FreeMockScreen extends ConsumerStatefulWidget {
  const FreeMockScreen({super.key});

  @override
  ConsumerState<FreeMockScreen> createState() => _FreeMockScreenState();
}

class _FreeMockScreenState extends ConsumerState<FreeMockScreen> {
  int? _rootGroupId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(mockTestNotifierProvider.notifier).fetchRootGroups();
      final rootGroups = ref.read(mockTestNotifierProvider).rootGroups;
      
      final freeMockGroup = rootGroups.firstWhere(
        (g) => g.title.toLowerCase() == 'free mock',
        orElse: () => rootGroups.isNotEmpty ? rootGroups.first : TestGroupModel(id: -1, title: '', isActive: false),
      );

      if (freeMockGroup.id != -1) {
        setState(() => _rootGroupId = freeMockGroup.id);
        await ref.read(mockTestNotifierProvider.notifier).fetchGroupDetail(freeMockGroup.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockState = ref.watch(mockTestNotifierProvider);
    final groupDetail = _rootGroupId != null ? mockState.groupDetails[_rootGroupId] : null;

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
          'Free Mock',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: mockState.isLoading && groupDetail == null
          ? const CardListSkeleton()
          : groupDetail == null
              ? const Center(child: Text('No Mock Series Found'))
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: ListView.separated(
                    itemCount: groupDetail.children?.length ?? 0,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final series = groupDetail.children![index];
                      return _buildSeriesCard(context, series);
                    },
                  ),
                ),
    );
  }

  Widget _buildSeriesCard(BuildContext context, TestGroupModel series) {
    return GestureDetector(
      onTap: () {
        // We'll need to update MockSeriesDetailScreen to handle TestGroupModel
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockSeriesDetailScreen(seriesGroup: series),
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
                'assets/icons/domus/paid_mock.png', // Default icon for now
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.logo_dev, size: 48, color: Colors.red),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                series.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
