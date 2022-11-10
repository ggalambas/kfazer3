import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/user_avatar.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

/// Shows all the task details
class TaskDetails extends ConsumerWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

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
    //TODO get participanting users
    final user = ref.watch(currentUserStateProvider);
    final workspace =
        ref.watch(workspaceStreamProvider(task.workspaceId)).valueOrNull;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: kSpace),
        children: [
          ListTile(
            onTap: () {},
            //TODO task state
            leading: Icon(task.state.icon),
            title: Text(longVersionState),
            iconColor: dateStateColor,
            textColor: dateStateColor,
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text('Participants'.hardcoded),
          ),
          for (var i = 0; i < 3; i++)
            ListTile(
              contentPadding: secondLevelPadding,
              leading: UserAvatar(user),
              title: Text(user.name),
            ),
          ListTile(
            contentPadding: secondLevelPadding,
            //TODO show subtasks
            onTap: () => showNotImplementedAlertDialog(context: context),
            leading: const Icon(Icons.segment),
            title: Text('Subtasks'.hardcoded),
          ),
          if (workspace != null)
            ListTile(
              onTap: () => context.goNamed(
                AppRoute.group.name,
                params: {'groupId': workspace.id},
              ),
              leading: Avatar.fromWorkspace(workspace, radius: 16),
              title: Text(workspace.title),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNotImplementedAlertDialog(
            context: context), //TODO Mark as completed
        child: const Icon(Icons.check),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              tooltip: 'Delegate'.hardcoded,
              onPressed: () => showNotImplementedAlertDialog(
                  context: context), //TODO Delegate task
              icon: const Icon(Icons.double_arrow),
            ),
            IconButton(
              tooltip: 'Split'.hardcoded,
              onPressed: () => showNotImplementedAlertDialog(
                  context: context), //TODO Split task
              icon: const Icon(Icons.view_stream),
            ),
            IconButton(
              tooltip: 'Deny'.hardcoded,
              onPressed: () => showNotImplementedAlertDialog(
                  context: context), //TODO Deny task
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
