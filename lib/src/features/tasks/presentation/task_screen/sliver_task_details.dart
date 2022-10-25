import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

/// Shows all the task details
class SliverTaskDetails extends ConsumerWidget {
  final Task task;
  const SliverTaskDetails({super.key, required this.task});

  //TODO where should longVersionState be done?
  String get longVersionState {
    final state = task.state.name;
    switch (task.state) {
      case TaskState.ongoing:
        //TODO where and how should we get the date state
        return '$state (near the deadline)'.hardcoded;
      case TaskState.delegated:
        //TODO depend on the date state
        return '$state (late)'.hardcoded;
      case TaskState.scheduled:
        return '$state for ${task.startDate}'.hardcoded;
      case TaskState.completed:
        return '$state on ${task.conclusionDate}'.hardcoded;
    }
  }

  //TODO where should dateStateColor this be done?
  Color? get dateStateColor {
    switch (task.state) {
      case TaskState.ongoing:
        //TODO depend on the date state
        return Colors.orange;
      case TaskState.delegated:
        //TODO depend on the date state
        return Colors.red;
      case TaskState.completed:
        return Colors.green;
      case TaskState.scheduled:
        return null;
    }
  }

  /// ListTile's default content padding
  /// with some extra space on the left
  EdgeInsetsGeometry get secondLevelPadding =>
      const EdgeInsets.symmetric(horizontal: 16)
          .add(const EdgeInsets.only(left: 56));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO get users in the responsability chain
    final user = ref.watch(currentUserStateProvider);
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          //TODO task state
          leading: Icon(task.state.icon),
          title: Text(longVersionState),
          iconColor: dateStateColor,
          textColor: dateStateColor,
        ),
        const ListTile(
          leading: Icon(Icons.people),
          title: Text('Chain of responsability'),
        ),
        for (var i = 0; i < 3; i++)
          ListTile(
            contentPadding: secondLevelPadding,
            leading: Avatar.fromUser(user),
            title: Text(user.name),
          ),
        ListTile(
          contentPadding: secondLevelPadding,
          //TODO show subtasks
          onTap: () => showNotImplementedAlertDialog(context: context),
          leading: const Icon(Icons.segment),
          title: Text('Subtasks'.hardcoded),
        ),
        ListTile(
          //TODO navigate to workspace?
          onTap: () => showNotImplementedAlertDialog(context: context),
          //TODO maybe use the workspace avatar?
          leading: const Icon(Icons.workspaces),
          title: Text('Workspace 1'.hardcoded),
        ),
      ]),
    );
  }
}
