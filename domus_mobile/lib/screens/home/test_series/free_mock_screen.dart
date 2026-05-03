import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/mock_test_model.dart';
import '../../../viewmodels/mock_test_notifier.dart';
import 'mock_series_detail_screen.dart';
import '../../../widgets/shimmer_loading.dart';
import 'widgets/test_series_scaffold.dart';

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

    return TestSeriesScaffold(
      title: 'Free Mock',
      body: mockState.isLoading && groupDetail == null
          ? const CardListSkeleton()
          : groupDetail == null
              ? const Center(child: Text('No Mock Series Found'))
              : Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockSeriesDetailScreen(seriesGroup: series),
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
                  'assets/icons/domus/paid_mock.png', // Default icon for now
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.school_outlined, size: 32, color: Colors.blueGrey),
                ),
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
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
