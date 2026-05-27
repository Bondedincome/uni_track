import 'package:flutter/material.dart';
import 'package:uni_track/shared/services/local_storage_service.dart';

class TodaySchedule extends StatefulWidget {
  const TodaySchedule({super.key});

  @override
  State<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends State<TodaySchedule> {
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
                "Today's Schedule",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _onAddSchedule,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add schedule',
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: [
                        Text(
                          "View all",
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
            future: localStorageService.getSchedule(),
            builder: (context, snapshot) {
              final items = snapshot.hasData ? snapshot.data! : [];
              if (items.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final color = _colorFromName(item['color'] as String?);
                  final time = item['time'] as String?;
                  final course = item['course'] as String? ?? '';
                  final location = item['location'] as String? ?? '';

                  return Column(
                    children: [
                      _buildScheduleItem(
                        courseCode: course,
                        location: location,
                        color: color,
                        time: time,
                      ),
                      if (index != items.length - 1) const SizedBox(height: 16),
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

  void _onAddSchedule() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        final courseCtrl = TextEditingController();
        final locationCtrl = TextEditingController();
        final timeCtrl = TextEditingController();
        String color = 'blue';

        return AlertDialog(
          title: const Text('Add schedule item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: courseCtrl,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Time (e.g. 09:00 AM)',
                  ),
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
                  'location': locationCtrl.text.trim(),
                  'time': timeCtrl.text.trim(),
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
      final items = await localStorageService.getSchedule();
      final id = 's${DateTime.now().millisecondsSinceEpoch}';
      items.add({
        'id': id,
        'course': result['course'],
        'location': result['location'],
        'time': result['time'],
        'color': result['color'],
      });
      await localStorageService.saveSchedule(items);
      setState(() {});
    }
  }

  Widget _buildScheduleItem({
    required String courseCode,
    required String location,
    required Color color,
    String? time,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.18), width: 1),
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Colored vertical indicator
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Course and location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Time with calendar icon (if provided)
          if (time != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Chevron
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Colors.grey[400],
            size: 22,
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
