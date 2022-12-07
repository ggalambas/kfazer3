import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/tasks/data/tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/header/sliver_task_header.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/not_found_task.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_comments.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_details.dart';
import 'package:kfazer3/src/routing/app_router.dart';

import 'header/sliver_task_bar.dart';
import 'header/sliver_task_tab_bar.dart';

//TODO task screen web

/// Shows the task page for a given task ID, along with actions to:
/// - delegate
/// - split
/// - reject
/// - mark as completed
///
/// The screen is composed of the following tabs:
/// 1. Details
/// 2. Comments
///
/// The correct tab is displayed (and updated)
/// based on the selected tab
///! The logic for the entire screen is implemented in the
///! [TaskScreenController],
/// while UI updates are handled by a [PageController].
class TaskScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String taskId;
  final TaskScreenTab? tab;

  const TaskScreen({
    super.key,
    required this.projectId,
    required this.taskId,
    this.tab,
  });

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class _TaskScreenState extends ConsumerState<TaskScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late var tab = widget.tab ?? TaskScreenTab.details;
  late final tabController = TabController(
    initialIndex: tab.index,
    length: TaskScreenTab.values.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    tabController.addListener(() => goToTab(tabController.index));
  }

  // override `wantKeepAlive` when using `AutomaticKeepAliveClientMixin`
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tab != null) {
      tab = widget.tab!;
      tabController.animateTo(tab.index);
    }
  }

  void goToTab(int i) {
    if (i != tab.index) {
      //TODO should we always call replace on cases like this one?
      context.replaceNamed(
        AppRoute.task.name,
        params: {
          'groupId': widget.projectId,
          'taskId': widget.taskId,
        },
        queryParams: {
          'view': TaskScreenTab.values[i].name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);

    final taskValue = ref.watch(taskProvider(widget.taskId));
    return AsyncValueWidget<Task?>(
      value: taskValue,
      //TODO loading widget
      data: (task) {
        if (task == null) return const NotFoundTask();
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverTaskBar(task: task),
              SliverTaskHeader(task: task),
              SliverTaskTabBar(controller: tabController, onTap: goToTab),
            ],
            //TODO nested scroll view causes body to have full height
            body: TabBarView(
              controller: tabController,
              children: [
                TaskDetails(task: task),
                TaskComments(task: task),
              ],
            ),
          ),
        );
      },
    );
  }
}
