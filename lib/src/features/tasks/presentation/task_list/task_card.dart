import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single task inside a card.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onPressed;

  const TaskCard({super.key, required this.task, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(kSpace * 2),
          child: Row(
            children: [
              Expanded(child: Text(task.description)),
            ],
          ),
        ),
      ),
    );
  }
}
