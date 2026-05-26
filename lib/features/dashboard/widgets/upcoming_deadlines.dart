import 'package:flutter/material.dart';

class UpcomingDeadlines extends StatelessWidget {
  const UpcomingDeadlines({super.key});

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
                "Upcoming Deadlines",
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

          const SizedBox(height: 16),

          // Deadline Item 1 - CS301
          _buildDeadlineItem(
            courseCode: "CS301",
            assignment: "Binary Tree Implementation",
            color: Colors.blue,
          ),

          const SizedBox(height: 12),

          // Deadline Item 2 - MATH201
          _buildDeadlineItem(
            courseCode: "MATH201",
            assignment: "Problem Set 4",
            color: Colors.orange,
          ),

          const SizedBox(height: 12),

          // Deadline Item 3 - CS302
          _buildDeadlineItem(
            courseCode: "CS302",
            assignment: "Sorting Algorithm Analysis",
            color: Colors.green,
          ),
        ],
      ),
    );
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
}
