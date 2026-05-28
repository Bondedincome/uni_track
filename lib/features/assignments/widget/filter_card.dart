import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assignment.dart';
import '../services/assignments_provider.dart';

enum AssignmentFilter { all, pending, completed, overdue }

extension AssignmentFilterX on AssignmentFilter {
  String get label {
    switch (this) {
      case AssignmentFilter.all:
        return 'All';
      case AssignmentFilter.pending:
        return 'Pending';
      case AssignmentFilter.completed:
        return 'Completed';
      case AssignmentFilter.overdue:
        return 'Overdue';
    }
  }

  bool matches(Assignment a, DateTime now) {
    switch (this) {
      case AssignmentFilter.all:
        return true;
      case AssignmentFilter.pending:
        return !a.completed && !a.dueDate.isBefore(now);
      case AssignmentFilter.completed:
        return a.completed;
      case AssignmentFilter.overdue:
        return !a.completed && a.dueDate.isBefore(now);
    }
  }
}

class FilterCard extends StatelessWidget {
  final AssignmentFilter selected;
  final ValueChanged<AssignmentFilter> onChanged;

  const FilterCard({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Consumer<AssignmentsProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final assignments = provider.assignments;

        final counts = {
          for (final f in AssignmentFilter.values)
            f: assignments.where((a) => f.matches(a, now)).length,
        };

        return Container(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AssignmentFilter.values.map((filter) {
                final isSelected = filter == selected;
                final count = counts[filter] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    label: Text(
                      '${filter.label} ($count)',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onChanged(filter),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 8.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
