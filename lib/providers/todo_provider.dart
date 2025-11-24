import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _todosSub;

  List<Todo> _items = [];
  List<Todo> get items => List.unmodifiable(_items);

  User? _user;

  TodoProvider() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen(_bindToUser);
  }

  void _bindToUser(User? user) {
    _user = user;
    _todosSub?.cancel();
    _items = [];
    notifyListeners();

    if (user == null) return;

    final col = _db
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .orderBy('createdAt', descending: true);

    _todosSub = col.snapshots().listen((snap) {
      _items = snap.docs.map((d) => Todo.fromDoc(d)).toList();
      notifyListeners();
    });
  }

  Future<void> add(String title, {DateTime? dueDate}) async {
    final u = _user;
    if (u == null || title.trim().isEmpty) return;
    await _db.collection('users').doc(u.uid).collection('todos').add({
      'title': title.trim(),
      'done': false,
      'createdAt': FieldValue.serverTimestamp(),
      if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate),
    });
  }

  Future<void> toggle(String id) async {
    final u = _user;
    if (u == null) return;
    final ref = _db.collection('users').doc(u.uid).collection('todos').doc(id);
    final doc = await ref.get();
    final current = (doc.data()?['done'] ?? false) as bool;
    await ref.update({'done': !current});
  }

  Future<void> remove(String id) async {
    final u = _user;
    if (u == null) return;
    await _db
        .collection('users')
        .doc(u.uid)
        .collection('todos')
        .doc(id)
        .delete();
  }

  Future<void> clearCompleted() async {
    final u = _user;
    if (u == null) return;
    final q = await _db
        .collection('users')
        .doc(u.uid)
        .collection('todos')
        .where('done', isEqualTo: true)
        .get();
    final batch = _db.batch();
    for (final d in q.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _todosSub?.cancel();
    super.dispose();
  }
}
