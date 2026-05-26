import 'package:flutter/material.dart';
import 'package:uni_track/core/theme/app_theme.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 600;
          final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

          // Responsive calculations based on available width
          final cardWidth = isSmallScreen
              ? screenWidth * 0.28 // 28% of screen on mobile
              : (isMediumScreen ? 140.0 : 160.0);

          final cardPadding = isSmallScreen ? 16.0 : 20.0;
          final iconSize = isSmallScreen ? 26.0 : 32.0;
          final valueFontSize = isSmallScreen ? 20.0 : 24.0;
          final labelFontSize = isSmallScreen ? 11.0 : 13.0;
          final gapBetweenCards = isSmallScreen ? 12.0 : 16.0;

          // Translate up so the cards visually dock into the header above
          final translateY = isSmallScreen ? -36.0 : -44.0;
          return Transform.translate(
            offset: Offset(0, translateY),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatCard(
                    icon: Icons.menu_book_rounded,
                    label: 'Courses',
                    value: '12',
                    width: cardWidth,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                    valueFontSize: valueFontSize,
                    labelFontSize: labelFontSize,
                  ),
                  SizedBox(width: gapBetweenCards),
                  _buildStatCard(
                    icon: Icons.timer_outlined,
                    label: 'Pending',
                    value: '3',
                    width: cardWidth,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                    valueFontSize: valueFontSize,
                    labelFontSize: labelFontSize,
                  ),
                  SizedBox(width: gapBetweenCards),
                  _buildStatCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'GPA',
                    value: '3.8',
                    width: cardWidth,
                    cardPadding: cardPadding,
                    iconSize: iconSize,
                    valueFontSize: valueFontSize,
                    labelFontSize: labelFontSize,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required double width,
    required double cardPadding,
    required double iconSize,
    required double valueFontSize,
    required double labelFontSize,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBabyBlue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryNavy, size: iconSize),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.primaryNavy,
                fontSize: valueFontSize,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: labelFontSize,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
