import 'package:flutter/material.dart';
import 'package:uni_track/core/theme/app_theme.dart';
import 'package:uni_track/features/dashboard/widgets/semester_progress.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          // Date at top left
          Text(
            "Thursday, March 12",
            style: TextStyle(
              color: AppTheme.accentBabyBlue.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          // Row with greeting and profile pic
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting text
              const Text(
                "Good morning, Alex 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              // Profile picture at top right
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentBabyBlue, width: 2),
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

          // Pending assignments text
          const Text(
            "You have 3 pending assignments",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 24),
          const SemesterProgress(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
