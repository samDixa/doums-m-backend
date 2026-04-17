import 'package:flutter/material.dart';
import 'dart:async';
import 'package:domus_mobile/screens/home/testimonials_screen.dart';
import 'package:domus_mobile/screens/home/job_portal_screen.dart';

class JobPortalAndTestimonialsSection extends StatelessWidget {
  const JobPortalAndTestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobPortalInner(context),
          const SizedBox(height: 32),
          _buildTestimonialsInner(context),
        ],
      ),
    );
  }

  Widget _buildJobPortalInner(BuildContext context) {
    return Column(
      children: [
        _buildJobPortalHeader(context),
        const SizedBox(height: 20),
        _buildJobPortalBanners(),
      ],
    );
  }

  Widget _buildJobPortalHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JobPortalScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6FA),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.2),
                color: const Color(0xFFE2E7ED),
              ),
              child:
                  const Icon(Icons.school, color: Color(0xFF1B3B5F), size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text("Job Portal",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.black),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildJobPortalBanners() {
    return const AutoScrollingBannerCarousel();
  }

  Widget _buildTestimonialsInner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Testimonials", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        const SizedBox(height: 16),
        const TestimonialFadeCarousel(),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestimonialsScreen()),
                  );
                },
                child: const Text("More",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}

class AutoScrollingBannerCarousel extends StatefulWidget {
  const AutoScrollingBannerCarousel({super.key});

  @override
  State<AutoScrollingBannerCarousel> createState() => _AutoScrollingBannerCarouselState();
}

class _AutoScrollingBannerCarouselState extends State<AutoScrollingBannerCarousel> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 9999, viewportFraction: 0.85);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
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
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final bannerIndex = index % 2;
          if (bannerIndex == 0) {
            return _buildGradientBanner("EDUCATION", const [Colors.orange, Colors.pinkAccent]);
          } else {
            return _buildGradientBanner("GRADUATION", const [Colors.black87, Colors.black], isDark: true);
          }
        },
      ),
    );
  }

  Widget _buildGradientBanner(String title, List<Color> colors, {bool isDark = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: colors),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TestimonialFadeCarousel extends StatefulWidget {
  const TestimonialFadeCarousel({super.key});

  @override
  State<TestimonialFadeCarousel> createState() => _TestimonialFadeCarouselState();
}

class _TestimonialFadeCarouselState extends State<TestimonialFadeCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  // Mock data for testimonials
  final List<Map<String, String>> _testimonials = [
    {
      'image': 'https://i.pravatar.cc/150?img=11',
      'name': 'Dr. Abhishek Shukla',
      'subtitle': 'NTET 2024 Certified\nMadhya Pradesh',
      'review': 'The language used in this book is simple and easy to grasp, making it very helpful for students.',
      'quote': '"Success is not just about hard work; it\'s about working smart with the right resources."'
    },
    {
      'image': 'https://i.pravatar.cc/150?img=12',
      'name': 'Dr. Sarah Jenkins',
      'subtitle': 'AIAPGET 2024 Topper\nDelhi',
      'review': 'A must-have resource for anyone preparing for competitive exams in homoeopathy.',
      'quote': '"Knowledge is power, but proper guidance is the key to unlocking it."'
    },
    {
      'image': 'https://i.pravatar.cc/150?img=13',
      'name': 'Dr. Ramesh Kumar',
      'subtitle': 'Medical Officer\nRajasthan',
      'review': 'The mock tests provided were exactly what I needed to boost my confidence.',
      'quote': '"Practice makes perfect, and this platform makes practice perfect."'
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _testimonials.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int prevIndex = (_currentIndex - 1 + _testimonials.length) % _testimonials.length;
    final int nextIndex = (_currentIndex + 1) % _testimonials.length;
    final double cardWidth = MediaQuery.of(context).size.width * 0.85;

    return SizedBox(
      height: 380, 
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Left Card (Previous)
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(-cardWidth * 0.65, 0),
              child: SizedBox(
                width: cardWidth,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _buildTestimonialCard(_testimonials[prevIndex], key: ValueKey(prevIndex), isCenter: false),
                ),
              ),
            ),
          ),
          
          // Right Card (Next)
          Align(
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(cardWidth * 0.65, 0),
              child: SizedBox(
                width: cardWidth,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: _buildTestimonialCard(_testimonials[nextIndex], key: ValueKey(nextIndex), isCenter: false),
                ),
              ),
            ),
          ),
          
          // Center Card (Current)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: cardWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _buildTestimonialCard(_testimonials[_currentIndex], key: ValueKey(_currentIndex), isCenter: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Map<String, String> data, {Key? key, required bool isCenter}) {
    final titleColor = isCenter ? Colors.blue : Colors.blue.withOpacity(0.3);
    final textColor = isCenter ? Colors.black : Colors.black26;
    final subtitleColor = isCenter ? Colors.blue : Colors.blue.withOpacity(0.3);
    
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: isCenter ? Colors.white : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isCenter ? [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, spreadRadius: 5, offset: const Offset(0, 15)),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 0, offset: const Offset(0, 5))
        ] : [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Prevent user scrolling, just for overflow
        child: Column(
          children: [
            Text("Congratulations", style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: isCenter ? const [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)] : [],
                image: DecorationImage(
                  image: NetworkImage(data['image']!),
                  fit: BoxFit.cover,
                  colorFilter: isCenter ? null : ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.lighten),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(data['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor)),
            const SizedBox(height: 4),
            Text(data['subtitle']!, textAlign: TextAlign.center, style: TextStyle(color: subtitleColor, fontSize: 12)),
            const SizedBox(height: 16),
            Text(
              data['review']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: isCenter ? FontWeight.w500 : FontWeight.normal, color: textColor),
            ),
            const SizedBox(height: 12),
            Text(
              data['quote']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: isCenter ? FontWeight.w500 : FontWeight.normal, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
