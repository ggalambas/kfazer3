import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

/// Shows the task page for a given task ID.
class TaskScreen extends ConsumerWidget {
  final String taskId;
  const TaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskValue = ref.watch(taskProvider(taskId));
    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueWidget<Task?>(
        value: taskValue,
        data: (task) => task == null
            ? NotFoundWidget(message: 'Task not found'.hardcoded)
            : CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    padding: EdgeInsets.all(kSpace),
                    child: TaskDetails(task: task),
                  ),
                ],
              ),
      ),
    );
  }
}

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
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(kSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(task.description, style: theme.textTheme.titleLarge),
          Space(),
          Text(task.state.name),
        ],
      ),
    );
  }
}
