class Todo {
  final String id;
  final String title;
  final bool done;

  Todo({required this.id, required this.title, this.done = false});

  Todo copyWith({String? id, String? title, bool? done}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "title": title, "done": done};
  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(id: json["id"], title: json["title"], done: json["done"] as bool);
}
