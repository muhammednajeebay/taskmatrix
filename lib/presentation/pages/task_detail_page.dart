import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;
  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Detail #$taskId')),
      body: const Center(child: Text('Task Detail Placeholder')),
    );
  }
}
