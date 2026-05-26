import 'package:flutter/material.dart';
import 'package:uni_track/features/assignments/screens/assignment_screen.dart';
import 'package:uni_track/features/courses/screens/courses_screen.dart';
import 'package:uni_track/features/dashboard/screens/dashboard_screen.dart';
import 'package:uni_track/features/gpa/screens/gpa_screen.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CoursesScreen(),
    AssignmentScreen(),
    GpaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'GPA'),
        ],
      ),
    );
  }
}