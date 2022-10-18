import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Shows all the task details along with actions to:
/// - delegate
/// - split
/// - reject
/// - mark as completed
class TaskDetails extends StatelessWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(task.description, style: context.textTheme.titleLarge),
          Space(),
          Text(task.state.name),
        ],
      ),
    );
  }
}
