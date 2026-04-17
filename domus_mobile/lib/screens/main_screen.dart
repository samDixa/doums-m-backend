import 'package:flutter/material.dart';
import 'package:domus_mobile/screens/home/home_screen.dart';
import 'package:domus_mobile/screens/courses/course_list_screen.dart';
import 'package:domus_mobile/screens/profile/profile_screen.dart';
import 'package:domus_mobile/screens/chat/chat_list_screen.dart';
import 'package:domus_mobile/widgets/main_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CourseListScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
