import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(value: todo.done, onChanged: (_) => onToggle()),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null,
            color: todo.done ? Colors.grey : null,
          ),
        ),
        onTap: onToggle,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
