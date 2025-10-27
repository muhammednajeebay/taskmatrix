import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Task #$index'),
            subtitle: const Text('Placeholder task'),
            onTap: () => GoRouter.of(context).push('/tasks/$index'),
          );
        },
      ),
    );
  }
}
