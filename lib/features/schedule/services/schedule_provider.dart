import 'package:flutter/foundation.dart';
import '../../../shared/services/database_service.dart';
import '../models/schedule_item.dart';

class ScheduleProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<ScheduleItem> _items = [];

  List<ScheduleItem> get items => _items;

  List<ScheduleItem> itemsForToday([DateTime? now]) {
    final reference = now ?? DateTime.now();
    final filtered = _items.where((i) => i.occursOn(reference)).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    return filtered;
  }

  Future<void> loadSchedule() async {
    _items = await _db.getScheduleItems();
    notifyListeners();
  }

  Future<void> addItem(ScheduleItem item) async {
    _items.add(item);
    await _db.saveScheduleItems(_items);
    notifyListeners();
  }

  Future<void> updateItem(String id, ScheduleItem updated) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = updated;
      await _db.saveScheduleItems(_items);
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    await _db.saveScheduleItems(_items);
    notifyListeners();
  }
}
