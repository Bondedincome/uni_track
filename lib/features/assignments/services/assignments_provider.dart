import 'package:flutter/material.dart';
import '../../../shared/services/database_service.dart';
import '../models/assignment.dart';

class AssignmentsProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    _assignments = await _db.getAssignments();
    notifyListeners();
  }

  Future<void> addAssignment(Assignment assignment) async {
    _assignments.add(assignment);
    await _db.saveAssignments(_assignments);
    notifyListeners();
  }

  Future<void> updateAssignment(String id, Assignment updatedAssignment) async {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
      await _db.saveAssignments(_assignments);
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(String id) async {
    _assignments.removeWhere((a) => a.id == id);
    await _db.saveAssignments(_assignments);
    notifyListeners();
  }
}
