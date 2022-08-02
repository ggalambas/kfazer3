import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single task inside a card.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onPressed;

  const TaskCard({super.key, required this.task, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceVariant,
      margin: const EdgeInsets.all(2),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: kSpace * 2,
            vertical: kSpace,
          ),
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension,
          ),
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
