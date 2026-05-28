import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/features/semester/services/semester_provider.dart';

class SemesterProgress extends StatelessWidget {
  const SemesterProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<SemesterProvider>(
      builder: (context, semester, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _showEditDialog(context, semester),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              screenHeight * 0.07,
              screenWidth * 0.05,
              screenHeight * 0.03,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 148, 151, 244),
              borderRadius: BorderRadius.circular(30),
            ),
            child: semester.isConfigured
                ? _buildConfigured(semester)
                : _buildEmpty(),
          ),
        );
      },
    );
  }

  Widget _buildConfigured(SemesterProvider semester) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Semester Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Week ${semester.currentWeek} of ${semester.totalWeeks}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SizedBox(
            width: double.infinity,
            child: LinearProgressIndicator(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              value: semester.progress,
              minHeight: 8,
              backgroundColor: const Color.fromARGB(255, 116, 114, 204),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        Text(
          '${semester.progressPercent}% Complete',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Semester Progress',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tap to set your semester start & end dates',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    SemesterProvider semester,
  ) async {
    DateTime? start = semester.start;
    DateTime? end = semester.end;

    final result = await showDialog<_DateRangeResult>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            String fmt(DateTime? d) => d == null
                ? 'Pick a date'
                : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

            return AlertDialog(
              title: const Text('Semester dates'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Start date'),
                    subtitle: Text(fmt(start)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: start ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => start = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('End date'),
                    subtitle: Text(fmt(end)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate:
                            end ?? (start ?? DateTime.now()).add(
                              const Duration(days: 7 * 16),
                            ),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => end = picked);
                    },
                  ),
                ],
              ),
              actions: [
                if (semester.isConfigured)
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(
                      const _DateRangeResult(clear: true),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (start == null || end == null) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('Pick both start and end dates'),
                        ),
                      );
                      return;
                    }
                    if (!end!.isAfter(start!)) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('End date must be after start date'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(ctx).pop(
                      _DateRangeResult(start: start, end: end),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;
    if (result.clear) {
      await semester.clear();
    } else if (result.start != null && result.end != null) {
      await semester.setDates(result.start!, result.end!);
    }
  }
}

class _DateRangeResult {
  final DateTime? start;
  final DateTime? end;
  final bool clear;

  const _DateRangeResult({this.start, this.end, this.clear = false});
}
