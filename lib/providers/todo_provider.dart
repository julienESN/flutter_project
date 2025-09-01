import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  static const _storageKey = 'todos_v1';
  List<Todo> _items = [];

  List<Todo> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_storageKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .cast<Map<String, dynamic>>()
          .map(Todo.fromJson)
          .toList();
      _items = list;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(_items.map((t) => t.toJson()).toList());
    await sp.setString(_storageKey, raw);
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    _items.insert(
      0,
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    final idx = _items.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _items[idx] = _items[idx].copyWith(done: !_items[idx].done);
    await _persist();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((t) => t.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> clearCompleted() async {
    _items.removeWhere((t) => t.done);
    await _persist();
    notifyListeners();
  }
}
