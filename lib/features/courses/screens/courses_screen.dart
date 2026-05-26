import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../services/courses_provider.dart';
import '../widget/course_cards.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: Consumer<CoursesProvider>(
        builder: (context, provider, child) {
          if (provider.courses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'No courses yet. Tap + to add your first course.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(children: [
              CourseCards(
                courses: provider.courses,
                onEdit: (course) => _showCourseDialog(context, course),
              )
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCourseDialog(BuildContext context, [Course? existingCourse]) {
    final formKey = GlobalKey<FormState>();
    String code = existingCourse?.code ?? '';
    String name = existingCourse?.name ?? '';
    String instructor = existingCourse?.instructor ?? '';
    int credits = existingCourse?.credits ?? 3;
    Color selectedColor = existingCourse?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingCourse == null ? 'Add New Course' : 'Edit Course'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: code,
                        decoration: const InputDecoration(labelText: 'Course Code'),
                        onSaved: (value) => code = value!.trim(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(labelText: 'Course Name'),
                        onSaved: (value) => name = value!.trim(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        initialValue: instructor,
                        decoration: const InputDecoration(labelText: 'Instructor'),
                        onSaved: (value) => instructor = value!.trim(),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Credits'),
                        initialValue: credits.toString(),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => credits = int.tryParse(value!) ?? 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          if (int.tryParse(value) == null) return 'Enter a number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Color>(
                        decoration: const InputDecoration(labelText: 'Color'),
                        value: selectedColor,
                        items: Colors.primaries.map((color) => DropdownMenuItem(
                          value: color,
                          child: Row(
                            children: [
                              Container(width: 24, height: 24, color: color),
                              const SizedBox(width: 8),
                              Text(_colorName(color)),
                            ],
                          ),
                        )).toList(),
                        onChanged: (color) {
                          setState(() { selectedColor = color!; });
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
                      final provider = context.read<CoursesProvider>();
                      if (existingCourse == null) {
                        final newCourse = Course(
                          id: DateTime.now().toString(),
                          code: code,
                          name: name,
                          instructor: instructor,
                          credits: credits,
                          color: selectedColor,
                          progress: 0.0,
                        );
                        provider.addCourse(newCourse);
                      } else {
                        final updatedCourse = Course(
                          id: existingCourse.id,
                          code: code,
                          name: name,
                          instructor: instructor,
                          credits: credits,
                          color: selectedColor,
                          progress: existingCourse.progress,
                        );
                        provider.updateCourse(existingCourse.id, updatedCourse);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(existingCourse == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper to get a readable color name (optional)
  String _colorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.deepPurple) return 'Deep Purple';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.lightBlue) return 'Light Blue';
    if (color == Colors.cyan) return 'Cyan';
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.green) return 'Green';
    if (color == Colors.lightGreen) return 'Light Green';
    if (color == Colors.lime) return 'Lime';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.amber) return 'Amber';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.deepOrange) return 'Deep Orange';
    if (color == Colors.brown) return 'Brown';
    if (color == Colors.grey) return 'Grey';
    if (color == Colors.blueGrey) return 'Blue Grey';
    return 'Custom';
  }
}
