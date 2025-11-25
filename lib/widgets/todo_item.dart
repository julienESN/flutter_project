import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onShowContextMenu;
  final VoidCallback onEditTitle;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onShowContextMenu,
    required this.onEditTitle,
  });

  @override
  Widget build(BuildContext context) {
    final dueText = _dueText(todo.dueDate);
    final iconColor = _dueColor(todo.dueDate);

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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onSecondaryTap: onShowContextMenu,
        onLongPress: onShowContextMenu,
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (todo.priority != TodoPriority.none) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _priorityColor(todo.priority),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Checkbox(value: todo.done, onChanged: (_) => onToggle()),
            ],
          ),
          title: GestureDetector(
            onTap: onEditTitle,
            child: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.done ? TextDecoration.lineThrough : null,
                color: todo.done ? Colors.grey : null,
              ),
            ),
          ),
          onTap: onToggle,
          subtitle: todo.dueDate == null
              ? null
              : Row(
                  children: [
                    Icon(Icons.event, size: 16, color: iconColor),
                    const SizedBox(width: 4),
                    Text(dueText),
                  ],
                ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  Color _dueColor(DateTime? dueDate) {
    if (dueDate == null) return Colors.grey;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
    if (target.isBefore(today)) return Colors.red;
    if (target.difference(today).inDays == 0) return Colors.orange;
    return Colors.blue;
  }

  String _dueText(DateTime? dueDate) {
    if (dueDate == null) return 'Pas d\'échéance';
    final formatted = _formatDate(dueDate);
    final suffix = _dueSuffix(dueDate);
    return suffix == null ? formatted : '$formatted $suffix';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String? _dueSuffix(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final delta = target.difference(today).inDays;

    String plural(int value) => value.abs() > 1 ? 's' : '';

    if (delta > 0) {
      return '($delta jour${plural(delta)} restant${plural(delta)})';
    }
    if (delta < 0) {
      final late = delta.abs();
      return '($late jour${plural(late)} en retard)';
    }
    return '(0 jour restant)';
  }

  Color _priorityColor(TodoPriority p) {
    switch (p) {
      case TodoPriority.urgent:
        return Colors.red;
      case TodoPriority.perso:
        return Colors.green;
      case TodoPriority.work:
        return Colors.blue;
      case TodoPriority.none:
        return Colors.transparent;
    }
  }
}
