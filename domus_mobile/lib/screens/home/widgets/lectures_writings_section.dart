import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/screens/courses/my_lectures_screen.dart';
import 'package:domus_mobile/viewmodels/home_notifier.dart';
import 'package:domus_mobile/widgets/shimmer_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LecturesWritingsSection extends ConsumerWidget {
  const LecturesWritingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);
    
    return Column(
      children: [
        _buildMyLectures(context),
        const SizedBox(height: 6),
        _buildDoctorsWritings(homeState),
      ],
    );
  }

  Widget _buildMyLectures(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Lectures',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 16),
          _buildLectureItem("Physics Chapter 1 || Lecture 2", 0.6, 'https://as1.ftcdn.net/v2/jpg/04/18/34/01/1000_F_418340176_t0j8uW0mQkQd3wP3k3gX2vU6B5kU4M8J.jpg', "1:15:59"),
          _buildLectureItem("Chemistry Chapter 1 || Lecture 2", 0.3, 'https://as2.ftcdn.net/v2/jpg/02/72/79/11/1000_F_272791168_MZyH6y9Q5GZkP6B6F5M5W5Z5v5U6B5k.jpg', "1:15:59"),
          _buildLectureItem("Maths Chapter 1 || Lecture 3", 0.1, 'https://as1.ftcdn.net/v2/jpg/03/18/69/05/1000_F_318690566_n8C3y2G4g9E8R4W3m3b5X7H5v5U6B5kU.jpg', "1:15:59"),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyLecturesScreen()),
                );
              },
              child: const Text("More",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLectureItem(String title, double progress, String imageUrl, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerSkeleton(
                  height: 65,
                  width: 100,
                  borderRadius: 8,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.school, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Icon(Icons.more_vert, color: Colors.black, size: 22),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    color: const Color(0xFF0D6EFD), // Bright blue like image
                    backgroundColor: Colors.grey.shade300,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 12, // Increased from 10
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Made bold like image
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsWritings(HomeState homeState) {
    final articles = homeState.articles;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Doctor's Writings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (homeState.isLoading)
            const ListSkeleton(itemCount: 3)
          else if (articles.isEmpty)
            ...[
              _buildWritingItem("The Future of Homoeopathy", 'https://i.pravatar.cc/150?u=1'),
              _buildWritingItem("Case Study: Chronic Migraines", 'https://i.pravatar.cc/150?u=2'),
              _buildWritingItem("Understanding Materia Medica", 'https://i.pravatar.cc/150?u=3'),
            ]
          else
            ...articles.take(3).map((article) => _buildWritingItem(article.title, 'https://i.pravatar.cc/150?u=${article.id}')),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {},
                child: const Text("View All",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget _buildWritingItem(String title, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 24,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => const ShimmerSkeleton(
                width: 48,
                height: 48,
                shape: BoxShape.circle,
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 24,
                child: Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
