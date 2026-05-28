import 'package:flutter/foundation.dart';
import '../../../shared/services/storage_adapter.dart';

class SemesterProvider with ChangeNotifier {
  static const _startKey = 'semester_start';
  static const _endKey = 'semester_end';

  DateTime? _start;
  DateTime? _end;

  DateTime? get start => _start;
  DateTime? get end => _end;

  bool get isConfigured => _start != null && _end != null;

  /// 0.0 - 1.0 progress through the semester. Returns 0 when unset.
  double get progress {
    if (_start == null || _end == null) return 0.0;
    final now = DateTime.now();
    final total = _end!.difference(_start!).inMilliseconds;
    if (total <= 0) return 0.0;
    final elapsed = now.difference(_start!).inMilliseconds;
    final ratio = elapsed / total;
    if (ratio <= 0) return 0.0;
    if (ratio >= 1) return 1.0;
    return ratio;
  }

  int get totalWeeks {
    if (_start == null || _end == null) return 0;
    final days = _end!.difference(_start!).inDays;
    if (days <= 0) return 0;
    return (days / 7).ceil();
  }

  int get currentWeek {
    if (_start == null || _end == null) return 0;
    final now = DateTime.now();
    if (now.isBefore(_start!)) return 0;
    if (now.isAfter(_end!)) return totalWeeks;
    final days = now.difference(_start!).inDays;
    final week = (days / 7).floor() + 1;
    if (week < 1) return 1;
    if (week > totalWeeks) return totalWeeks;
    return week;
  }

  int get progressPercent => (progress * 100).round();

  Future<void> load() async {
    final s = await StorageAdapter.getString(_startKey);
    final e = await StorageAdapter.getString(_endKey);
    _start = (s != null) ? DateTime.tryParse(s) : null;
    _end = (e != null) ? DateTime.tryParse(e) : null;
    notifyListeners();
  }

  Future<void> setDates(DateTime start, DateTime end) async {
    _start = start;
    _end = end;
    await StorageAdapter.setString(_startKey, start.toIso8601String());
    await StorageAdapter.setString(_endKey, end.toIso8601String());
    notifyListeners();
  }

  Future<void> clear() async {
    _start = null;
    _end = null;
    await StorageAdapter.remove(_startKey);
    await StorageAdapter.remove(_endKey);
    notifyListeners();
  }
}
