import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:domus_mobile/screens/home/payment_screen.dart';
import 'package:domus_mobile/services/cart_service.dart';
import 'package:domus_mobile/widgets/app_toast.dart';
import 'package:domus_mobile/viewmodels/home_notifier.dart';
import 'package:domus_mobile/core/constants/api_constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:domus_mobile/widgets/shimmer_loading.dart';

class CourseCarousel extends ConsumerStatefulWidget {
  const CourseCarousel({super.key});

  @override
  ConsumerState<CourseCarousel> createState() => _CourseCarouselState();
}

class _CourseCarouselState extends ConsumerState<CourseCarousel> {
  late PageController _pageController;
  double _currentPage = 10000.0;
  Timer? _autoScrollTimer;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 10000);
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page ?? 10000.0;
        });
      }
    });
  }

  void _startAutoScroll(int itemCount) {
    _autoScrollTimer?.cancel();
    if (itemCount <= 1) return;
    
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final batches = homeState.featuredBatches;

    if (homeState.isLoading && batches.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              'FEATURED BATCHES',
              style: TextStyle(
                color: Color(0xFF1B3B5F),
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          CarouselSkeleton(height: 550),
        ],
      );
    }

    if (batches.isEmpty) {
      return const SizedBox.shrink();
    }

    // Initialize auto-scroll once data is available
    if (!_isDataInitialized && batches.isNotEmpty) {
      _isDataInitialized = true;
      // Start near the middle of a large range (multiple of batches.length)
      final middlePage = (10000 ~/ batches.length) * batches.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(middlePage);
          _startAutoScroll(batches.length);
        }
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: [
                Text(
                  'FEATURED BATCHES',
                  style: TextStyle(
                    color: Color(0xFF1B3B5F),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'v1.8',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 550,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                // Restart timer on manual swipe to avoid overlap
                _startAutoScroll(batches.length);
              },
              itemCount: 100000, // Very large number for infinite feel
              itemBuilder: (context, index) {
                final batchIndex = index % batches.length;
                final batch = batches[batchIndex];
                
                double difference = index - _currentPage;
                double scale = 1 - (0.12 * difference.abs());
                scale = scale.clamp(0.88, 1.0);
                
                double opacity = 1 - (0.4 * difference.abs());
                opacity = opacity.clamp(0.6, 1.0);
  
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: _buildCourseCard(context, batch),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, dynamic batch) {
    final course = batch.course;
    if (course == null) return const SizedBox.shrink();

    final imageUrl = (course.batchImage != null && course.batchImage!.isNotEmpty)
        ? (course.batchImage!.startsWith('http') ? course.batchImage! : '${ApiConstants.baseUrl}${course.batchImage}')
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header Row: New Badge + WhatsApp + Info ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (course.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07A5F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                const SizedBox(width: 40),
              Row(
                children: [
                  if (course.whatsappUrl != null) ...[
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse(course.whatsappUrl!)),
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 24,
                        color: Color(0xFF25D366),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  const Icon(
                    Icons.info,
                    size: 26,
                    color: Color(0xFF2196F3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Circular Logo ──
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.white,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.school_rounded,
                          size: 50,
                          color: Color(0xFF1B3B5F),
                        ),
                      )
                    : const Icon(
                        Icons.school_rounded,
                        size: 50,
                        color: Color(0xFF1B3B5F),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Title ──
          Text(
            course.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A2E44),
              height: 1.15,
            ),
          ),

          // ── Subtitle ──
          Text(
            course.subtitle ?? "Complete batch",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1A2E44),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // ── Price Pill ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                'Price: ₹${course.price?.toInt() ?? 0} (Discount: ${course.discountPercentage?.toInt() ?? 0}%)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Dates ──
          if (course.startDate != null) ...[
            _buildDateRow('Starts: ${DateFormat('yyyy-MM-dd').format(course.startDate!)}'),
            const SizedBox(height: 10),
          ],
          if (course.endDate != null) ...[
            _buildDateRow('Ends: ${DateFormat('yyyy-MM-dd').format(course.endDate!)}'),
          ],

          const Spacer(),

          // ── Buy Now Button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _navigateToPayment(context, course),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Add to cart ──
          GestureDetector(
            onTap: () {
              CartService().addToCart();
              AppToast.showSuccess(context, '${course.title} added to cart');
            },
            child: const Text(
              'Add to cart',
              style: TextStyle(
                color: Color(0xFF5C9CE6),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPayment(BuildContext context, dynamic course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          courseTitle: course.title,
          price: '₹${course.price ?? 0}',
          originalPrice: course.discountPercentage != null
              ? '₹${((course.price ?? 0) / (1 - course.discountPercentage! / 100)).toStringAsFixed(0)}'
              : '₹${course.price ?? 0}',
          startDate: course.startDate != null
              ? DateFormat('yyyy-MM-dd').format(course.startDate!)
              : '-',
          endDate: course.endDate != null
              ? DateFormat('yyyy-MM-dd').format(course.endDate!)
              : '-',
          duration: 'Complete Batch',
        ),
      ),
    );
  }

  Widget _buildDateRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const Text('🗓️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2E44),
            ),
          ),
        ],
      ),
    );
  }
}
