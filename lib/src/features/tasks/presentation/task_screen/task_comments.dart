import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';

/// Shows the task comments
class TaskComments extends ConsumerWidget {
  final Task task;
  const TaskComments({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Text('comments...'),
      // bottomSheet: ,
    );
  }
}
