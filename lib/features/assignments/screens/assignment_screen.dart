import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/features/assignments/widget/filter_card.dart';
import 'package:uni_track/features/assignments/widget/task_card.dart';
import '../services/assignments_provider.dart';
import '../../courses/services/courses_provider.dart';
import '../models/assignment.dart';
import '../../courses/models/course.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Consumer2<AssignmentsProvider, CoursesProvider>(
        builder: (context, assignmentsProvider, coursesProvider, child) {
          final assignments = assignmentsProvider.assignments;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                const FilterCard(),
                if (assignments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No assignments yet. Tap + to add one.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...assignments.map((assignment) {
                    final course = coursesProvider.courses.cast<Course?>().firstWhere(
                          (c) => c?.id == assignment.courseId,
                          orElse: () => null,
                        );
                        
                    return TaskCard(
                      assignment: assignment,
                      course: course,
                      onEdit: () => _showAssignmentDialog(context, existingAssignment: assignment),
                      onDelete: () => assignmentsProvider.deleteAssignment(assignment.id),
                      onStatusChanged: (val) {
                        if (val != null) {
                          assignmentsProvider.updateAssignment(
                            assignment.id,
                            Assignment(
                              id: assignment.id,
                              courseId: assignment.courseId,
                              title: assignment.title,
                              dueDate: assignment.dueDate,
                              completed: val,
                              notifyBefore: assignment.notifyBefore,
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 80), // bottom padding for fab
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAssignmentDialog(BuildContext context, {Assignment? existingAssignment}) {
    final formKey = GlobalKey<FormState>();
    final coursesProvider = context.read<CoursesProvider>();
    final courses = coursesProvider.courses;

    if (courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a course first before creating assignments.')),
      );
      return;
    }

    String title = existingAssignment?.title ?? '';
    String? courseId = existingAssignment?.courseId ?? (courses.isNotEmpty ? courses.first.id : null);
    DateTime dueDate = existingAssignment?.dueDate ?? DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingAssignment == null ? 'Add Assignment' : 'Edit Assignment'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        onSaved: (value) => title = value!.trim(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Course'),
                        value: courseId,
                        items: courses.map((course) {
                          return DropdownMenuItem(
                            value: course.id,
                            child: Text(course.code),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => courseId = val);
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Due Date'),
                        subtitle: Text('${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => dueDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final provider = context.read<AssignmentsProvider>();
                      
                      final newAssignment = Assignment(
                        id: existingAssignment?.id ?? DateTime.now().toString(),
                        courseId: courseId!,
                        title: title,
                        dueDate: dueDate,
                        completed: existingAssignment?.completed ?? false,
                      );
                      
                      if (existingAssignment == null) {
                        provider.addAssignment(newAssignment);
                      } else {
                        provider.updateAssignment(existingAssignment.id, newAssignment);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(existingAssignment == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}