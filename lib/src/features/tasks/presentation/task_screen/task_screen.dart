import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/tasks/data/tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/not_found_task.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

import 'task_details.dart';

/// Shows the task page for a given task ID.
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
          appBar: AppBar(),
          body: CustomScrollView(
            slivers: [
              ResponsiveSliverCenter(
                padding: EdgeInsets.all(kSpace),
                child: TaskDetails(task: task),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {}, //TODO Mark as completed
            child: const Icon(Icons.check),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Delegate'.hardcoded,
                  onPressed: () {}, //TODO Delegate task
                  icon: const Icon(Icons.double_arrow),
                ),
                IconButton(
                  tooltip: 'Split'.hardcoded,
                  onPressed: () {}, //TODO Split task
                  icon: const Icon(Icons.view_stream),
                ),
                IconButton(
                  tooltip: 'Deny'.hardcoded,
                  onPressed: () {}, //TODO Deny task
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
