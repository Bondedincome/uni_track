import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/features/assignments/services/assignments_provider.dart';
import 'package:uni_track/features/courses/models/course.dart';
import 'package:uni_track/features/courses/services/courses_provider.dart';

class UpcomingDeadlines extends StatelessWidget {
  const UpcomingDeadlines({super.key});

  static const int _maxToShow = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.02,
        screenWidth * 0.05,
        screenHeight * 0.03,
      ),
      decoration: BoxDecoration(color: theme.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Deadlines',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer2<AssignmentsProvider, CoursesProvider>(
            builder: (context, assignmentsProvider, coursesProvider, _) {
              final upcoming =
                  assignmentsProvider.assignments
                      .where((a) => !a.completed)
                      .toList()
                    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

              if (upcoming.isEmpty) {
                return _buildEmptyState();
              }

              final items = upcoming.take(_maxToShow).toList();

              return Column(
                children: List.generate(items.length, (index) {
                  final assignment = items[index];
                  final course = _findCourse(
                    coursesProvider.courses,
                    assignment.courseId,
                  );
                  final color = course?.color ?? Colors.blue;
                  final courseCode = course?.code ?? 'No course';

                  return Column(
                    children: [
                      _buildDeadlineItem(
                        courseCode: courseCode,
                        assignment: assignment.title,
                        dueDate: assignment.dueDate,
                        color: color,
                      ),
                      if (index != items.length - 1) const SizedBox(height: 12),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Course? _findCourse(List<Course> courses, String courseId) {
    for (final c in courses) {
      if (c.id == courseId) return c;
    }
    return null;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        'No upcoming deadlines',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }

  Widget _buildDeadlineItem({
    required String courseCode,
    required String assignment,
    required DateTime dueDate,
    required Color color,
  }) {
    final bg = color.withOpacity(0.06);
    final border = color.withOpacity(0.28);
    final dueText = _formatDueDate(dueDate);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              courseCode,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dueText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: color,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;

    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    if (diff < 7) return 'Due in $diff days';
    return 'Due ${dueDate.year}-${_pad(dueDate.month)}-${_pad(dueDate.day)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
