import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum TaskMenuOption with LocalizedEnum {
  activity,
  delete;

  @override
  String locName(BuildContext context) {
    switch (this) {
      case activity:
        return context.loc.activity;
      case delete:
        return context.loc.delete;
    }
  }
}

class TaskMenuButton extends ConsumerStatefulWidget {
  final Task task;
  const TaskMenuButton({super.key, required this.task});

  @override
  ConsumerState<TaskMenuButton> createState() => _TaskMenuButtonState();
}

class _TaskMenuButtonState extends ConsumerState<TaskMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in TaskMenuOption.values)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: option == TaskMenuOption.delete
                  ? TextStyle(color: context.colorScheme.error)
                  : null,
            ),
          ),
      ],
      onSelected: (option) {
        switch (option) {
          case TaskMenuOption.activity:
            //TODO show task activity
            showNotImplementedAlertDialog(context: context);
            break;
          case TaskMenuOption.delete:
            //TODO delete task
            showNotImplementedAlertDialog(context: context);
            break;
        }
      },
    );
  }
}
