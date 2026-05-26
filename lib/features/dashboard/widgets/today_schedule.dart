import 'package:flutter/material.dart';

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

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
      decoration: BoxDecoration(
        color: theme.cardColor,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(30),
        //   bottomRight: Radius.circular(30),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.04),
        //     spreadRadius: 1,
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
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

          const SizedBox(height: 16),

          // Schedule Item 1 - CS301 Data Structures
          _buildScheduleItem(
            courseCode: "CS301 Data Structures",
            location: "Lab B-204",
            color: Colors.blue,
            time: "09:00 AM",
          ),

          const SizedBox(height: 16),

          // Schedule Item 2 - MATH201 Calculus II
          _buildScheduleItem(
            courseCode: "MATH201 Calculus II",
            location: "Room A-101",
            color: Colors.orange,
            time: "11:30 AM",
          ),

          const SizedBox(height: 16),

          // Schedule Item 3 - ENG101 Tech Writing
          _buildScheduleItem(
            courseCode: "ENG101 Tech Writing",
            location: "Room C-305",
            color: Colors.green,
            time: "02:00 PM",
          ),
        ],
      ),
    );
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
}
