import 'package:flutter/material.dart';
import '../../../shared/services/database_service.dart';
import '../models/course.dart';

class CoursesProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    _courses = await _db.getCourses();
    notifyListeners();
  }

  Future<void> addCourse(Course course) async {
    _courses.add(course);
    await _db.saveCourses(_courses);
    notifyListeners();
  }

  Future<void> updateCourse(String id, Course updatedCourse) async {
    final index = _courses.indexWhere((c) => c.id == id);
    if (index != -1) {
      _courses[index] = updatedCourse;
      await _db.saveCourses(_courses);
      notifyListeners();
    }
  }

  Future<void> deleteCourse(String id) async {
    _courses.removeWhere((c) => c.id == id);
    await _db.saveCourses(_courses);
    notifyListeners();
  }
}
