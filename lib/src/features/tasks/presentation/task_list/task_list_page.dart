import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/task_grid.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// This is the root widget of the tasks page,
/// which is composed of the following tabs:
/// 1. Ongoing
/// 2. Delegated
/// 3. Scheduled
///
/// The correct tab is displayed (and updated)
/// based on the selected tab
///! The logic for the entire screen is implemented in the
///! [TaskListPageController],
/// while UI updates are handled by a [PageController].
class TaskListPage extends StatefulWidget {
  final String workspaceId;
  final TaskState? taskState;
  const TaskListPage({super.key, required this.workspaceId, this.taskState});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late var taskState = widget.taskState ?? TaskState.ongoing;
  late final controller = TabController(
    initialIndex: taskState.index,
    length: TaskState.tabs.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() => goToTab(controller.index));
  }

  // override `wantKeepAlive` when using `AutomaticKeepAliveClientMixin`
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.taskState != null) {
      taskState = widget.taskState!;
      controller.animateTo(taskState.index);
    }
  }

  void goToTab(int i) {
    if (i != taskState.index) {
      context.goNamed(
        AppRoute.workspace.name,
        params: {
          'workspaceId': widget.workspaceId,
        },
        queryParams: {
          'menu': WorkspaceMenu.tasks.name,
          'state': TaskState.tabs[i].name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);

    // Return a Column with a TabBar and a TabBarView containing the tabs.
    // This allows for a nice scroll animation when switching between tabs.
    return Column(
      children: [
        TabBar(
          controller: controller,
          onTap: goToTab,
          // Indicator and label colors must be defined for the light mode
          indicatorColor: context.colorScheme.onBackground,
          labelColor: context.colorScheme.onBackground,
          tabs: [
            for (final taskState in TaskState.tabs)
              Tab(text: taskState.name.hardcoded),
          ],
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (_) => true,
            child: TabBarView(
              controller: controller,
              children: [
                for (final taskState in TaskState.tabs)
                  CustomScrollView(
                    key: PageStorageKey(taskState.name),
                    slivers: [
                      ResponsiveSliverCenter(
                        padding: EdgeInsets.all(kSpace),
                        child: TaskGrid(taskState: taskState),
                      ),
                    ],
                  ),
                // TaskStateView(taskState: taskState)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
