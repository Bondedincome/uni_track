import 'package:flutter/material.dart';
import 'package:uni_track/features/dashboard/widgets/dashboard_header.dart';
// import 'package:uni_track/features/dashboard/widgets/semester_progress.dart';
import 'package:uni_track/features/dashboard/widgets/stats_cards.dart';
import 'package:uni_track/features/dashboard/widgets/today_schedule.dart';
import 'package:uni_track/features/dashboard/widgets/upcoming_deadlines.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("UniTrack Dashboard"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DashboardHeader(),
            // SemesterProgress(),
            StatsCards(),
            UpcomingDeadlines(),
            TodaySchedule(),
          ],
        ),
      ),
    );
  }
}
