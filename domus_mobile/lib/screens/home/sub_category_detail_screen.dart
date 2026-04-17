import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../models/home_category_model.dart';
import '../../widgets/shimmer_loading.dart';

class SubCategoryDetailScreen extends ConsumerStatefulWidget {
  final int subCategoryId;
  final String title;

  const SubCategoryDetailScreen({
    super.key,
    required this.subCategoryId,
    required this.title,
  });

  @override
  ConsumerState<SubCategoryDetailScreen> createState() => _SubCategoryDetailScreenState();
}

class _SubCategoryDetailScreenState extends ConsumerState<SubCategoryDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SubCategoryDetailModel? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get('/api/v1/home/app_sub_category/${widget.subCategoryId}');
      setState(() {
        _detail = SubCategoryDetailModel.fromJson(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF021B3A),
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: ListSkeleton(itemCount: 4))
          : _error != null
              ? Center(child: Text("Error loading content: $_error", style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Container(
                      color: const Color(0xFF021B3A),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.blue,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.white70,
                        tabs: const [
                          Tab(icon: Icon(Icons.video_library), text: "Lectures"),
                          Tab(icon: Icon(Icons.picture_as_pdf), text: "Notes"),
                          Tab(icon: Icon(Icons.quiz), text: "MCQs"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                        ),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLecturesTab(),
                            _buildNotesTab(),
                            _buildTestsTab(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLecturesTab() {
    final lectures = _detail?.lectures ?? [];
    if (lectures.isEmpty) {
      return const Center(child: Text("No lectures found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF1B3B5F), child: Icon(Icons.play_arrow, color: Colors.white)),
            title: Text(lecture['title'] ?? 'Lecture', style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Open video player
              final url = lecture['video_url'];
              if (url != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening Video: $url')));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    final notes = _detail?.notes ?? [];
    if (notes.isEmpty) {
      return const Center(child: Text("No notes found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.picture_as_pdf, color: Colors.white)),
            title: Text(note['title'] ?? 'Note PDF', style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              final url = note['pdf_url'];
              if (url != null) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening PDF Document...')));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTestsTab() {
    final tests = _detail?.tests ?? [];
    if (tests.isEmpty) {
      return const Center(child: Text("No exams/tests found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check_circle, color: Colors.white)),
            title: Text("Test #${test['test_id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Multiple Choice Questions"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               // Placeholder for test detail navigation
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening Test ID: ${test['test_id']}')));
            },
          ),
        );
      },
    );
  }
}
