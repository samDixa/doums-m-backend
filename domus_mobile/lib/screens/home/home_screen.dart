import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/viewmodels/home_notifier.dart';

// Extracted Widget Sections
import 'package:domus_mobile/screens/home/widgets/home_header.dart';
import 'package:domus_mobile/screens/home/widgets/domus_homoeopathica_section.dart';
import 'package:domus_mobile/screens/home/widgets/test_series_section.dart';
import 'package:domus_mobile/screens/home/widgets/courses_section.dart';
import 'package:domus_mobile/screens/home/widgets/job_testimonials_section.dart';
import 'package:domus_mobile/screens/home/widgets/lectures_writings_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFF021B3A),
          body: SafeArea(
            bottom: false,
            child: Container(
              color: const Color(0xFF021B3A),
              child: Column(
                children: [
                  HomeHeader(
                    onMenuPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFF021B3A),
                      onRefresh: () => ref
                          .read(homeNotifierProvider.notifier)
                          .fetchHomeData(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Top Blue Section (Banner)
                            Container(
                              width: double.infinity,
                              color: const Color(0xFF021B3A),
                              child: const Column(
                                children: [
                                  BannerCarousel(),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                            // Main Content Area (Rounded Top)
                            Transform.translate(
                              offset: const Offset(0, -10),
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildNumberedSection('1', 'Domus Homoeopathica', const DomusHomoeopathicaSection()),
                                    const SizedBox(height: 12),
                                    _buildNumberedSection('2', 'Test Series', const TestSeriesSection()),
                                    const SizedBox(height: 12),
                                    _buildNumberedSection('3', 'Featured Batches', const CourseCarousel()),
                                    const SizedBox(height: 12),
                                    _buildNumberedSection('4', 'Lectures & Writings', const LecturesWritingsSection()),
                                    const SizedBox(height: 12),
                                    _buildNumberedSection('5', 'Job Portal & Testimonials', const JobPortalAndTestimonialsSection()),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildNumberedSection(String number, String name, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '#$number - $name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
