import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/screens/notifications/notification_screen.dart';
import 'package:domus_mobile/screens/cart/cart_screen.dart';
import 'package:domus_mobile/services/cart_service.dart';
import 'package:domus_mobile/viewmodels/home_notifier.dart';
import 'package:domus_mobile/core/constants/api_constants.dart';
import 'package:domus_mobile/widgets/shimmer_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomeHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.white),
              onPressed: onMenuPressed,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFD1DCE5).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon:
                      Icon(Icons.search, color: Color(0xFF4A5568), size: 24),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<int>(
            valueListenable: CartService().cartCount,
            builder: (context, count, child) {
              return _buildBadgeIcon(
                Icons.shopping_basket,
                Colors.yellow[700]!,
                count.toString(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
          _buildBadgeIcon(
            Icons.notifications,
            Colors.orange,
            "1",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, Color color, String badge, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFFD1DCE5), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              badge,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ));
  }
}

class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({super.key});

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 9999);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final banners = homeState.banners;

    if (homeState.isLoading && banners.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const ShimmerSkeleton(height: 160, borderRadius: 16),
      );
    }

    if (banners.isEmpty) {
      // Fallback or empty state if no banners are added in Admin Panel
      return const SizedBox.shrink();
    }

    // Restart timer only if we have more than 1 banner
    if (banners.length > 1 && (_timer == null || !_timer!.isActive)) {
      _startTimer();
    } else if (banners.length <= 1) {
      _timer?.cancel();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length > 1 ? null : 1, // Infinite if > 1 banner
        itemBuilder: (context, index) {
          final bannerIndex = index % banners.length;
          final banner = banners[bannerIndex];
          
          final imageUrl = banner.imageUrl.startsWith('http') 
              ? banner.imageUrl 
              : '${ApiConstants.baseUrl}${banner.imageUrl}';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerSkeleton(
                  height: 160,
                  borderRadius: 16,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error_outline, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
