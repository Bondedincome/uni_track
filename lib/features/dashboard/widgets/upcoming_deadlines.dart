import 'package:flutter/material.dart';
import 'package:uni_track/shared/services/local_storage_service.dart';

class UpcomingDeadlines extends StatefulWidget {
  const UpcomingDeadlines({super.key});

  @override
  State<UpcomingDeadlines> createState() => _UpcomingDeadlinesState();
}

class _UpcomingDeadlinesState extends State<UpcomingDeadlines> {
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Deadlines",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _onAddDeadline,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add deadline',
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: [
                        Text(
                          "See all",
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
            ],
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: localStorageService.getDeadlines(),
            builder: (context, snapshot) {
              final items = snapshot.hasData ? snapshot.data! : [];
              if (items.isEmpty) return const SizedBox.shrink();

              return Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final course = item['course'] as String? ?? '';
                  final assignment = item['assignment'] as String? ?? '';
                  final color = _colorFromName(item['color'] as String?);

                  return Column(
                    children: [
                      _buildDeadlineItem(
                        courseCode: course,
                        assignment: assignment,
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

  void _onAddDeadline() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        final courseCtrl = TextEditingController();
        final assignmentCtrl = TextEditingController();
        String color = 'blue';

        return AlertDialog(
          title: const Text('Add deadline'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: courseCtrl,
                  decoration: const InputDecoration(labelText: 'Course code'),
                ),
                TextField(
                  controller: assignmentCtrl,
                  decoration: const InputDecoration(labelText: 'Assignment'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: color,
                  items: const [
                    DropdownMenuItem(value: 'blue', child: Text('Blue')),
                    DropdownMenuItem(value: 'orange', child: Text('Orange')),
                    DropdownMenuItem(value: 'green', child: Text('Green')),
                  ],
                  onChanged: (v) => color = v ?? 'blue',
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop({
                  'course': courseCtrl.text.trim(),
                  'assignment': assignmentCtrl.text.trim(),
                  'color': color,
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final items = await localStorageService.getDeadlines();
      final id = 'd${DateTime.now().millisecondsSinceEpoch}';
      items.add({
        'id': id,
        'course': result['course'],
        'assignment': result['assignment'],
        'color': result['color'],
      });
      await localStorageService.saveDeadlines(items);
      setState(() {});
    }
  }

  Widget _buildDeadlineItem({
    required String courseCode,
    required String assignment,
    required Color color,
  }) {
    final bg = color.withOpacity(0.06);
    final border = color.withOpacity(0.28);
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
          // Colored indicator with course code inside
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

          // Assignment name
          Expanded(
            child: Text(
              assignment,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Chevron with subtle background
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

  Color _colorFromName(String? name) {
    switch (name) {
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
      default:
        return Colors.blue;
    }
  }
}
