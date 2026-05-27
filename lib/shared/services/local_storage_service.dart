import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kUserNameKey = 'user_name';
  static const _kAssignmentsKey = 'assignments';
  static const _kScheduleKey = 'schedule';
  static const _kDeadlinesKey = 'deadlines';

  bool _initialized = false;
  late Box _box;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _box = await Hive.openBox('appBox');

    // Attempt migration from SharedPreferences if present
    await _migrateFromSharedPreferencesIfNeeded();

    await _ensureDefaults();
    _initialized = true;
  }

  Future<void> _migrateFromSharedPreferencesIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var migrated = false;

      if (prefs.containsKey(_kUserNameKey) &&
          !_box.containsKey(_kUserNameKey)) {
        final name = prefs.getString(_kUserNameKey);
        if (name != null) {
          await _box.put(_kUserNameKey, name);
          migrated = true;
        }
      }

      if (prefs.containsKey(_kAssignmentsKey) &&
          !_box.containsKey(_kAssignmentsKey)) {
        final raw = prefs.getString(_kAssignmentsKey);
        if (raw != null) {
          try {
            final list = jsonDecode(raw) as List<dynamic>;
            await _box.put(_kAssignmentsKey, List<dynamic>.from(list));
            migrated = true;
          } catch (_) {
            await _box.put(_kAssignmentsKey, raw);
            migrated = true;
          }
        }
      }

      if (prefs.containsKey(_kScheduleKey) &&
          !_box.containsKey(_kScheduleKey)) {
        final raw = prefs.getString(_kScheduleKey);
        if (raw != null) {
          try {
            final list = jsonDecode(raw) as List<dynamic>;
            await _box.put(_kScheduleKey, List<dynamic>.from(list));
            migrated = true;
          } catch (_) {
            await _box.put(_kScheduleKey, raw);
            migrated = true;
          }
        }
      }

      if (prefs.containsKey(_kDeadlinesKey) &&
          !_box.containsKey(_kDeadlinesKey)) {
        final raw = prefs.getString(_kDeadlinesKey);
        if (raw != null) {
          try {
            final list = jsonDecode(raw) as List<dynamic>;
            await _box.put(_kDeadlinesKey, List<dynamic>.from(list));
            migrated = true;
          } catch (_) {
            await _box.put(_kDeadlinesKey, raw);
            migrated = true;
          }
        }
      }

      if (migrated) {
        // optional: do not clear SharedPreferences automatically to avoid data loss
      }
    } catch (_) {
      // ignore migration errors and continue with defaults
    }
  }

  Future<void> _ensureDefaults() async {
    if (!_box.containsKey(_kUserNameKey)) {
      await _box.put(_kUserNameKey, 'Alex');
    }

    if (!_box.containsKey(_kAssignmentsKey)) {
      final defaultAssignments = [
        {
          "id": "a1",
          "title": "Binary Tree Implementation",
          "course": "CS301",
          "done": false,
        },
        {
          "id": "a2",
          "title": "Problem Set 4",
          "course": "MATH201",
          "done": false,
        },
        {
          "id": "a3",
          "title": "Sorting Algorithm Analysis",
          "course": "CS302",
          "done": false,
        },
      ];
      await _box.put(_kAssignmentsKey, defaultAssignments);
    }

    if (!_box.containsKey(_kScheduleKey)) {
      final defaultSchedule = [
        {
          "id": "s1",
          "course": "CS301 Data Structures",
          "location": "Lab B-204",
          "time": "09:00 AM",
          "color": "blue",
        },
        {
          "id": "s2",
          "course": "MATH201 Calculus II",
          "location": "Room A-101",
          "time": "11:30 AM",
          "color": "orange",
        },
        {
          "id": "s3",
          "course": "ENG101 Tech Writing",
          "location": "Room C-305",
          "time": "02:00 PM",
          "color": "green",
        },
      ];
      await _box.put(_kScheduleKey, defaultSchedule);
    }

    if (!_box.containsKey(_kDeadlinesKey)) {
      final defaultDeadlines = [
        {
          "id": "d1",
          "course": "CS301",
          "assignment": "Binary Tree Implementation",
          "color": "blue",
        },
        {
          "id": "d2",
          "course": "MATH201",
          "assignment": "Problem Set 4",
          "color": "orange",
        },
        {
          "id": "d3",
          "course": "CS302",
          "assignment": "Sorting Algorithm Analysis",
          "color": "green",
        },
      ];
      await _box.put(_kDeadlinesKey, defaultDeadlines);
    }
  }

  Future<String> getUserName() async {
    await init();
    final v = _box.get(_kUserNameKey);
    return v is String ? v : 'Alex';
  }

  Future<int> getPendingAssignmentsCount() async {
    await init();
    final raw = _box.get(_kAssignmentsKey);
    final list = _normalizeToList(raw);
    final pending = list.where((e) => (e['done'] == false)).length;
    return pending;
  }

  Future<List<Map<String, dynamic>>> getSchedule() async {
    await init();
    final raw = _box.get(_kScheduleKey);
    final list = _normalizeToList(raw);
    return List<Map<String, dynamic>>.from(list);
  }

  Future<List<Map<String, dynamic>>> getDeadlines() async {
    await init();
    final raw = _box.get(_kDeadlinesKey);
    final list = _normalizeToList(raw);
    return List<Map<String, dynamic>>.from(list);
  }

  Future<void> saveAssignments(List<Map<String, dynamic>> items) async {
    await init();
    await _box.put(_kAssignmentsKey, items);
  }

  Future<void> saveSchedule(List<Map<String, dynamic>> items) async {
    await init();
    await _box.put(_kScheduleKey, items);
  }

  Future<void> saveDeadlines(List<Map<String, dynamic>> items) async {
    await init();
    await _box.put(_kDeadlinesKey, items);
  }

  List<Map<String, dynamic>> _normalizeToList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      try {
        return List<Map<String, dynamic>>.from(raw);
      } catch (_) {
        // try to decode strings inside list
        return raw.map<Map<String, dynamic>>((e) {
          if (e is String) {
            try {
              return Map<String, dynamic>.from(jsonDecode(e));
            } catch (_) {
              return {};
            }
          }
          return Map<String, dynamic>.from(e);
        }).toList();
      }
    }

    if (raw is String) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return List<Map<String, dynamic>>.from(decoded);
      } catch (_) {
        return [];
      }
    }

    return [];
  }
}

final localStorageService = LocalStorageService();
