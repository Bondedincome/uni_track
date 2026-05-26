import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// StorageAdapter abstracts storage operations so we can switch
/// between SharedPreferences and Hive (or others) without changing
/// the rest of the app.
class StorageAdapter {
  static const _boxName = 'uni_track_storage';
  static Box<dynamic>? _box;
  static bool _useHive = false;

  /// Initialize storage. Prefers Hive when available.
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      _useHive = true;
    } catch (_) {
      _useHive = false;
      _box = null;
    }
  }

  static Future<List<String>> getStringList(String key) async {
    if (_useHive && _box != null) {
      final val = _box!.get(key);
      if (val == null) return [];
      if (val is List) return val.cast<String>();
      // if stored as single json string
      if (val is String) {
        final decoded = jsonDecode(val);
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key) ?? [];
    }
  }

  static Future<void> setStringList(String key, List<String> value) async {
    if (_useHive && _box != null) {
      await _box!.put(key, value);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, value);
    }
  }

  static Future<bool> containsKey(String key) async {
    if (_useHive && _box != null) {
      return _box!.containsKey(key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    }
  }

  /// Migrate a key from SharedPreferences (sourceList) into Hive box.
  static Future<void> migrateKeyFromPrefs(
    String key,
    List<String> sourceList,
  ) async {
    if (_useHive && _box != null) {
      await _box!.put(key, sourceList);
    }
  }
}
