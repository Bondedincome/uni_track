import 'package:flutter/material.dart';
import 'package:uni_track/core/theme/app_theme.dart';
import '../models/assignment.dart';
import '../../courses/models/course.dart';

class TaskCard extends StatelessWidget {
  final Assignment assignment;
  final Course? course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onStatusChanged;

  const TaskCard({
    super.key,
    required this.assignment,
    this.course,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate time left
    final now = DateTime.now();
    final difference = assignment.dueDate.difference(now);
    final isOverdue = difference.isNegative && !assignment.completed;
    
    String timeLeftText;
    if (assignment.completed) {
      timeLeftText = 'Completed';
    } else if (isOverdue) {
      timeLeftText = 'Overdue';
    } else if (difference.inDays > 0) {
      timeLeftText = '${difference.inDays}d ${difference.inHours % 24}h left';
    } else {
      timeLeftText = '${difference.inHours}h ${difference.inMinutes % 60}m left';
    }

    final stripColor = course?.color ?? AppTheme.accentBabyBlue;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course?.code ?? 'No Course',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryNavy,
                                  ),
                            ),
                            if (course?.name != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  course!.name,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: assignment.completed 
                              ? const Color(0xFFE6F4EA) 
                              : (isOverdue ? const Color(0xFFFCE8E8) : const Color(0xFFFFF7E6)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              assignment.completed 
                                  ? Icons.check_circle
                                  : (isOverdue ? Icons.error : Icons.access_time_sharp),
                              color: assignment.completed
                                  ? const Color(0xFF34A853)
                                  : (isOverdue ? const Color(0xFFEA4335) : const Color(0xFFFFB400)),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              timeLeftText,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: assignment.completed
                                        ? const Color(0xFF34A853)
                                        : (isOverdue ? const Color(0xFFEA4335) : const Color(0xFFFFB400)),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: assignment.completed,
                        onChanged: onStatusChanged,
                        activeColor: AppTheme.primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: Text(
                          assignment.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                decoration: assignment.completed ? TextDecoration.lineThrough : null,
                                color: assignment.completed ? Colors.grey : AppTheme.primaryNavy,
                              ),
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
