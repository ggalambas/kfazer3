import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

import 'task_card.dart';

/// A widget that displays the list of tasks that match the state.
class TaskGrid extends ConsumerWidget {
  final TaskState taskState;
  const TaskGrid({super.key, required this.taskState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListValue = ref.watch(filteredTaskListStreamProvider(taskState));
    return AsyncValueWidget<List<Task>>(
      value: taskListValue,
      data: (taskList) => taskList.isEmpty
          ? Center(
              child: Text(
                'No tasks to show'.hardcoded,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            )
          : TaskLayoutGrid(
              itemCount: taskList.length,
              itemBuilder: (context, i) {
                final task = taskList[i];
                return TaskCard(
                  task: task,
                  onPressed: () {
                    context.pushNamed(
                      AppRoute.task.name,
                      params: {
                        'workspaceId': task.workspaceId,
                        'taskId': task.id,
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

/// Grid widget with content-sized items.
/// See: https://codewithandrea.com/articles/flutter-layout-grid-content-sized-items/
class TaskLayoutGrid extends StatelessWidget {
  /// Total number of items to display.
  final int itemCount;

  /// Function used to build a widget for a given index in the grid.
  final Widget Function(BuildContext, int) itemBuilder;

  const TaskLayoutGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // use a LayoutBuilder to determine the crossAxisCount
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // 1 column for width < 500px
      // then add one more column for each 250px
      final crossAxisCount = max(1, width ~/ 300);
      // once the crossAxisCount is known, calculate the column and row sizes
      // set some flexible track sizes based on the crossAxisCount with 1.fr
      final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
      final numRows = (itemCount / crossAxisCount).ceil();
      // set all the row sizes to auto (self-sizing height)
      final rowSizes = List.generate(numRows, (_) => auto);
      // Custom layout grid. See: https://pub.dev/packages/flutter_layout_grid
      return LayoutGrid(
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        // render all the items with automatic child placement
        children: List.generate(itemCount, (i) => itemBuilder(context, i)),
      );
    });
  }
}
