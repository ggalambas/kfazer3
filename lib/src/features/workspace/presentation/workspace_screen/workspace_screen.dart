import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/task_list_page.dart';
import 'package:kfazer3/src/features/team/presentation/team_page.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_bar/workspace_bar.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';

import 'workspace_screen_controller.dart';

/// The three sub-routes that are presented as part of the workspace screen.
enum WorkspaceMenu { tasks, team, dashboard }

/// This is the root widget of the workspace screen, which is composed of 3 pages:
/// 1. Tasks page
/// 2. Team page
/// 3. Dashboard page
///
/// The correct page is displayed (and updated)
/// based on the selected menu
///! The logic for the entire screen is implemented in the
///! [WorkspaceScreenController],
/// while UI updates are handled by a [PageController].
class WorkspaceScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final WorkspaceMenu? menu;
  final TaskState? taskState;

  const WorkspaceScreen({
    super.key,
    required this.workspaceId,
    this.menu,
    this.taskState,
  });

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen>
    with AutomaticKeepAliveClientMixin {
  late var menu = widget.menu ?? WorkspaceMenu.tasks;
  late final controller = PageController(initialPage: menu.index);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final page = controller.page;
      if (page != null && page == page.toInt()) goToMenu(page.toInt());
    });
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
  void didUpdateWidget(WorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // perform a nice scroll animation to reveal the next page
    if (widget.menu != null &&
        controller.hasClients &&
        controller.position.hasViewportDimension) {
      menu = widget.menu!;
      controller.animateToPage(
        menu.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void goToMenu(int i) {
    if (i != menu.index) {
      //!
      // context.goNamed(
      //   AppRoute.group.name,
      //   params: {'groupId': widget.workspaceId},
      //   queryParams: {'menu': WorkspaceMenu.values[i].name},
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      workspaceScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    final workspaceValue =
        ref.watch(workspaceStreamProvider(widget.workspaceId));
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      //TODO loading widget
      data: (workspace) {
        if (workspace == null) return const NotFoundGroup();
        return Scaffold(
          appBar: WorkspaceBar(workspace: workspace),
          body: PageView(
            controller: controller,
            children: [
              TaskListPage(
                workspaceId: workspace.id,
                taskState: widget.taskState,
              ),
              const TeamPage(),
              const DashboardPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: goToMenu,
            selectedIndex: menu.index,
            //? labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            //? height: kBottomNavigationBarHeight,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.upcoming),
                label: context.loc.tasks,
              ),
              NavigationDestination(
                icon: const Icon(Icons.people),
                label: context.loc.team,
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights),
                label: context.loc.performance,
              ),
            ],
          ),
        );
      },
    );
  }
}
