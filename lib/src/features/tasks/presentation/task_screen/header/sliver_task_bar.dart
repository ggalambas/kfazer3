import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';

import 'task_menu_button.dart';

/// Custom [SliverAppBar] widget that is used by the [TaskScreen].
/// It shows the following actions:
/// - Delete button
/// - See activity button
///
class SliverTaskBar extends StatelessWidget {
  final Task task;
  const SliverTaskBar({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      actions: [
        IconButton(
          onPressed: () => showNotImplementedAlertDialog(
              context: context), //TODO open task edit screen
          icon: const Icon(Icons.edit),
        ),
        TaskMenuButton(task: task),
      ],
    );
  }
}
