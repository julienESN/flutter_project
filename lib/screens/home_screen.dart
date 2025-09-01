import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoProvider>().load();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoApp'),
        actions: [
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
                    onSubmitted: (v) async {
                      await context.read<TodoProvider>().add(v);
                      _ctrl.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    await context.read<TodoProvider>().add(_ctrl.text);
                    _ctrl.clear();
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('Aucune tâche pour le moment.'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, i) {
                      final t = todos[i];
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
}
