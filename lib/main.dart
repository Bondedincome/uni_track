import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/courses/services/courses_provider.dart';
import 'features/assignments/services/assignments_provider.dart';
import 'features/gpa/services/gpa_provider.dart';
import 'features/schedule/services/schedule_provider.dart';
import 'features/semester/services/semester_provider.dart';
import 'shared/widgets/app_bottom_navigation.dart';
import 'shared/services/storage_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageAdapter.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentsProvider()),
        ChangeNotifierProvider(create: (_) => GpaProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => SemesterProvider()),
      ],
      child: const UniTrackApp(),
    ),
  );
}

class UniTrackApp extends StatefulWidget {
  const UniTrackApp({super.key});

  @override
  State<UniTrackApp> createState() => _UniTrackAppState();
}

class _UniTrackAppState extends State<UniTrackApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesProvider>().loadCourses();
      context.read<AssignmentsProvider>().loadAssignments();
      context.read<GpaProvider>().loadGrades();
      context.read<ScheduleProvider>().loadSchedule();
      context.read<SemesterProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppBottomNavigation(),
    );
  }
}
