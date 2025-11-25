import 'package:cloud_firestore/cloud_firestore.dart';

enum TodoPriority { urgent, perso, work, none }

class Todo {
  final String id; // id du document Firestore
  final String title;
  final bool done;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final TodoPriority priority;
  final int order;

  Todo({
    required this.id,
    required this.title,
    this.done = false,
    this.createdAt,
    this.dueDate,
    this.priority = TodoPriority.none,
    this.order = 0,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? done,
    DateTime? createdAt,
    DateTime? dueDate,
    TodoPriority? priority,
    int? order,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'done': done,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
    if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate!),
    'priority': priority.name,
    'order': order,
  };

  static Todo fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Todo(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      done: (data['done'] ?? false) as bool,
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      dueDate: (data['dueDate'] is Timestamp)
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      priority: TodoPriority.values.firstWhere(
        (e) => e.name == (data['priority'] ?? 'none'),
        orElse: () => TodoPriority.none,
      ),
      order: (data['order'] ?? 0) as int,
    );
  }
}
