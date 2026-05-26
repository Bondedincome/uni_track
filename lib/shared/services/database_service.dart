import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/courses/models/course.dart';
import '../../features/assignments/models/assignment.dart';
import '../../features/gpa/models/grade_record.dart';
import 'storage_adapter.dart';

class DatabaseService {
  static const String _coursesKey = 'courses';
  static const String _assignmentsKey = 'assignments';
  static const String _gradesKey = 'grades';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();
  // Helper to get underlying string list and migrate if needed
  Future<List<String>> _getRawList(String key) async {
    final list = await StorageAdapter.getStringList(key);
    // If storage is Hive but key is empty and prefs had data, migrate
    if ((list.isEmpty)) {
      final prefs = await _prefs;
      final prefsList = prefs.getStringList(key) ?? [];
      if (prefsList.isNotEmpty) {
        // migrate into storage
        await StorageAdapter.migrateKeyFromPrefs(key, prefsList);
        return prefsList;
      }
    }
    return list;
  }

  Future<void> _setRawList(String key, List<String> value) async {
    await StorageAdapter.setStringList(key, value);
  }

  // Courses
  Future<List<Course>> getCourses() async {
    final coursesJson = await _getRawList(_coursesKey);
    return coursesJson
        .map((json) => Course.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCourses(List<Course> courses) async {
    final coursesJson = courses.map((c) => jsonEncode(c.toJson())).toList();
    await _setRawList(_coursesKey, coursesJson);
  }

  // Assignments
  Future<List<Assignment>> getAssignments() async {
    final assignmentsJson = await _getRawList(_assignmentsKey);
    return assignmentsJson
        .map((json) => Assignment.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveAssignments(List<Assignment> assignments) async {
    final assignmentsJson = assignments
        .map((a) => jsonEncode(a.toJson()))
        .toList();
    await _setRawList(_assignmentsKey, assignmentsJson);
  }

  // Grades
  Future<List<GradeRecord>> getGrades() async {
    final gradesJson = await _getRawList(_gradesKey);
    return gradesJson
        .map((json) => GradeRecord.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveGrades(List<GradeRecord> grades) async {
    final gradesJson = grades.map((g) => jsonEncode(g.toJson())).toList();
    await _setRawList(_gradesKey, gradesJson);
  }
}
