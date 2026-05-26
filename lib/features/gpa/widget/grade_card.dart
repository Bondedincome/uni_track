import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/core/theme/app_theme.dart';
import '../services/gpa_provider.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GpaProvider>(
      builder: (context, gpaProvider, child) {
        final gpa = gpaProvider.calculateGpa();
        
        String standing = 'Good Standing';
        if (gpa >= 3.5) standing = 'Dean\'s List';
        if (gpa < 2.0 && gpa > 0) standing = 'Academic Warning';
        if (gpa == 0.0) standing = 'No Grades Yet';

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryNavy.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top row with circular GPA and "Good" badge
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular GPA
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentBabyBlue, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentBabyBlue.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            gpa.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryNavy,
                            ),
                          ),
                          Text(
                            '/ 4.00',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Good" badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBabyBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      standing,
                      style: const TextStyle(
                        color: AppTheme.primaryNavy,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Current Semester GPA text
              Text(
                'Calculated GPA',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.primaryNavy.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
