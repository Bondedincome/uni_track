import 'package:flutter/material.dart';
import 'package:uni_track/features/gpa/widget/course_grade.dart';
import 'package:uni_track/features/gpa/widget/grade_card.dart';

class GpaScreen extends StatelessWidget {
  const GpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPA Calculator")),
      body: SingleChildScrollView(
        child: Column(children: [GradeCard(), CourseGrade()]),
      ),
    );
  }
}
