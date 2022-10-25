import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/tasks/data/tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_screen_tab.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/header/sliver_task_header.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/not_found_task.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/sliver_task_details.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

import 'header/sliver_task_bar.dart';
import 'header/sliver_task_tab_bar.dart';

//TODO task screen web

/// Shows the task page for a given task ID along with actions to:
/// - delegate
/// - split
/// - reject
/// - mark as completed
class TaskScreen extends ConsumerWidget {
  final String taskId;
  const TaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(taskProvider(taskId));
    return AsyncValueWidget<Task?>(
      value: taskValue,
      data: (task) {
        if (task == null) return const NotFoundTask();
        return Scaffold(
          body: DefaultTabController(
            length: TaskScreenTab.values.length,
            child: CustomScrollView(
              slivers: [
                SliverTaskBar(task: task),
                SliverTaskHeader(task: task),
                const SliverTaskTabBar(),
                SliverTaskDetails(task: task),
              ],
            ),
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
      },
    );
  }
}
