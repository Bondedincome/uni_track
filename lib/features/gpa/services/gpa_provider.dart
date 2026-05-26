import 'package:flutter/material.dart';
import '../../../shared/services/database_service.dart';
import '../models/grade_record.dart';

class GpaProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<GradeRecord> _grades = [];

  List<GradeRecord> get grades => _grades;

  Future<void> loadGrades() async {
    _grades = await _db.getGrades();
    notifyListeners();
  }

  Future<void> addOrUpdateGrade(GradeRecord record) async {
    final index = _grades.indexWhere((g) => g.courseId == record.courseId);
    if (index != -1) {
      _grades[index] = record;
    } else {
      _grades.add(record);
    }
    await _db.saveGrades(_grades);
    notifyListeners();
  }

  Future<void> deleteGrade(String courseId) async {
    _grades.removeWhere((g) => g.courseId == courseId);
    await _db.saveGrades(_grades);
    notifyListeners();
  }

  double calculateGpa() {
    if (_grades.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalCredits = 0;
    for (var grade in _grades) {
      totalPoints += grade.gradePoints * grade.credits;
      totalCredits += grade.credits;
    }
    if (totalCredits == 0) return 0.0;
    return totalPoints / totalCredits;
  }
}
