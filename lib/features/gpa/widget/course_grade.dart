import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../courses/services/courses_provider.dart';
import '../../courses/models/course.dart';
import '../services/gpa_provider.dart';
import '../models/grade_record.dart';

class CourseGrade extends StatelessWidget {
  const CourseGrade({super.key});

  static const Map<String, double> _gradeScale = {
    'A': 4.0, 'A-': 3.7, 'B+': 3.3, 'B': 3.0, 'B-': 2.7,
    'C+': 2.3, 'C': 2.0, 'C-': 1.7, 'D+': 1.3, 'D': 1.0, 'F': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer2<CoursesProvider, GpaProvider>(
      builder: (context, coursesProvider, gpaProvider, child) {
        final courses = coursesProvider.courses;
        
        if (courses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Add courses first to calculate your GPA.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course Grades',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tap to change grade',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor),
              // Course items
              ...courses.map((course) {
                final gradeRecord = gpaProvider.grades.cast<GradeRecord?>().firstWhere(
                  (g) => g?.courseId == course.id,
                  orElse: () => null,
                );

                String gradeText = gradeRecord == null 
                    ? 'None' 
                    : '${gradeRecord.gradeLetter} (${gradeRecord.gradePoints})';

                return Column(
                  children: [
                    _buildCourseItem(
                      context,
                      course,
                      gradeText,
                      gpaProvider,
                    ),
                    if (course != courses.last) Divider(color: theme.dividerColor),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseItem(
    BuildContext context,
    Course course,
    String gradeWithValue,
    GpaProvider gpaProvider,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showGradePicker(context, course, gpaProvider),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Course info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.code} · ${course.credits} credits',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Grade with dropdown indicator
            Row(
              children: [
                Text(
                  gradeWithValue,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: gradeWithValue == 'None' ? Colors.grey : null,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGradePicker(BuildContext context, Course course, GpaProvider gpaProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Grade for ${course.code}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _gradeScale.entries.map((entry) {
                    return ListTile(
                      title: Text('${entry.key} (${entry.value})'),
                      onTap: () {
                        gpaProvider.addOrUpdateGrade(
                          GradeRecord(
                            courseId: course.id,
                            gradeLetter: entry.key,
                            gradePoints: entry.value,
                            credits: course.credits,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
