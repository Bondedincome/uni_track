import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/core/theme/app_theme.dart';
import 'package:uni_track/features/assignments/services/assignments_provider.dart';
import 'package:uni_track/features/dashboard/widgets/semester_progress.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final now = DateTime.now();
    final dateLabel = _formatDate(now);
    final greeting = _greetingForHour(now.hour);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.06,
        screenWidth * 0.05,
        screenHeight * 0.04,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryNavy,
            AppTheme.primaryNavy.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel,
            style: TextStyle(
              color: AppTheme.accentBabyBlue.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$greeting 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentBabyBlue,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          Consumer<AssignmentsProvider>(
            builder: (context, assignmentsProvider, _) {
              final count = assignmentsProvider.assignments
                  .where((a) => !a.completed)
                  .length;
              final word = count == 1 ? 'assignment' : 'assignments';
              return Text(
                count == 0
                    ? "You're all caught up — no pending assignments"
                    : 'You have $count pending $word',
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              );
            },
          ),
          const SizedBox(height: 24),
          const SemesterProgress(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _formatDate(DateTime d) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayName = days[d.weekday - 1];
    final monthName = months[d.month - 1];
    return '$dayName, $monthName ${d.day}';
  }
}
