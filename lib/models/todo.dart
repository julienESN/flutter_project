import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id; // id du document Firestore
  final String title;
  final bool done;
  final DateTime? createdAt;
  final DateTime? dueDate;

  Todo({
    required this.id,
    required this.title,
    this.done = false,
    this.createdAt,
    this.dueDate,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? done,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'done': done,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
        if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate!),
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
    );
  }
}
