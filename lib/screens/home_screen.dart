import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';

enum SortOption { dueSoonestFirst, dueLatestFirst }

enum FilterOption { all, completedOnly, pendingOnly }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ctrl = TextEditingController();
  DateTime? _selectedDueDate;
  SortOption _sortOption = SortOption.dueSoonestFirst;
  FilterOption _filterOption = FilterOption.all;

  Future<void> _submitTodo() async {
    final text = _ctrl.text;
    if (text.trim().isEmpty) return;
    await context.read<TodoProvider>().add(text, dueDate: _selectedDueDate);
    _ctrl.clear();
    if (mounted) {
      setState(() => _selectedDueDate = null);
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _selectedDueDate ?? now,
    );
    if (picked != null && mounted) {
      setState(
        () =>
            _selectedDueDate = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().items;
    final completed = todos.where((t) => t.done).length;
    final displayedTodos = _applyViewPreferences(todos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes tâches'),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            tooltip: 'Supprimer les tâches terminées',
            onPressed: completed == 0
                ? null
                : () => context.read<TodoProvider>().clearCompleted(),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Ajouter une tâche...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submitTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 0,
                  child: OutlinedButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.event),
                    label: Text(
                      _selectedDueDate == null
                          ? 'Échéance'
                          : _formatDate(_selectedDueDate!),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submitTodo,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
          _BuildControls(
            sortOption: _sortOption,
            filterOption: _filterOption,
            onSortChanged: (value) =>
                setState(() => _sortOption = value ?? _sortOption),
            onFilterChanged: (value) =>
                setState(() => _filterOption = value ?? _filterOption),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('Aucune tâche pour le moment.'))
                : ListView.builder(
                    itemCount: displayedTodos.length,
                    itemBuilder: (context, i) {
                      final t = displayedTodos[i];
                      return TodoItem(
                        todo: t,
                        onToggle: () =>
                            context.read<TodoProvider>().toggle(t.id),
                        onDelete: () =>
                            context.read<TodoProvider>().remove(t.id),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('${todos.length} tâche(s) • $completed terminée(s)'),
          ),
        ],
      ),
    );
  }

  List<Todo> _applyViewPreferences(List<Todo> todos) {
    final filtered = todos.where((t) {
      switch (_filterOption) {
        case FilterOption.all:
          return true;
        case FilterOption.completedOnly:
          return t.done;
        case FilterOption.pendingOnly:
          return !t.done;
      }
    }).toList();

    int compareDueDates(Todo a, Todo b) {
      final dueA = a.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dueB = b.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dueA.compareTo(dueB);
    }

    switch (_sortOption) {
      case SortOption.dueSoonestFirst:
        filtered.sort((a, b) => compareDueDates(a, b));
        break;
      case SortOption.dueLatestFirst:
        filtered.sort((a, b) => compareDueDates(b, a));
        break;
    }

    return filtered;
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

class _BuildControls extends StatelessWidget {
  final SortOption sortOption;
  final FilterOption filterOption;
  final ValueChanged<SortOption?> onSortChanged;
  final ValueChanged<FilterOption?> onFilterChanged;

  const _BuildControls({
    required this.sortOption,
    required this.filterOption,
    required this.onSortChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<SortOption>(
            value: sortOption,
            decoration: const InputDecoration(
              labelText: 'Trier par',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: SortOption.dueSoonestFirst,
                child: Text('Échéance : la plus proche'),
              ),
              DropdownMenuItem(
                value: SortOption.dueLatestFirst,
                child: Text('Échéance : la plus lointaine'),
              ),
            ],
            onChanged: onSortChanged,
          ),
          const SizedBox(height: 8),
          SegmentedButton<FilterOption>(
            segments: const [
              ButtonSegment(value: FilterOption.all, label: Text('Toutes')),
              ButtonSegment(
                value: FilterOption.pendingOnly,
                label: Text('À faire'),
              ),
              ButtonSegment(
                value: FilterOption.completedOnly,
                label: Text('Réalisées'),
              ),
            ],
            selected: {filterOption},
            onSelectionChanged: (v) => onFilterChanged(v.first),
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }
}
