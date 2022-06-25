import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder_widget.dart';
import 'package:kfazer3/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/task_list_page.dart';
import 'package:kfazer3/src/features/team/team_page.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_bar/workspace_bar.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

/// The three sub-routes that are presented as part of the workspace screen.
enum WorkspaceMenu {
  tasks,
  team,
  dashboard;

  static const WorkspaceMenu main = WorkspaceMenu.tasks;
}

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
  final WorkspaceMenu menu;
  final TaskState? taskState;

  const WorkspaceScreen({
    super.key,
    required this.workspaceId,
    required this.menu,
    this.taskState,
  });

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen>
    with AutomaticKeepAliveClientMixin {
  late final controller = PageController(initialPage: widget.menu.index);

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
    if (controller.hasClients) {
      controller.animateToPage(
        widget.menu.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void goToMenu(int i) => context.goNamed(
        AppRoute.workspace.name,
        params: {'workspaceId': widget.workspaceId},
        queryParams: {'menu': WorkspaceMenu.values[i].name},
      );

  @override
  Widget build(BuildContext context) {
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);

    final workspaceValue = ref.watch(workspaceProvider(widget.workspaceId));
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      data: (workspace) {
        if (workspace == null) {
          return Material(
            child: EmptyPlaceholderWidget(
              message: 'You do not have access to this workspace. '
                      'Please contact a member to add you to their team'
                  .hardcoded,
            ),
          );
        }
        return Scaffold(
          appBar: WorkspaceBar(workspace: workspace),
          body: PageView(
            controller: controller,
            onPageChanged: goToMenu,
            children: [
              TaskListPage(
                workspaceId: workspace.id,
                state: widget.taskState,
              ),
              const TeamPage(),
              const DashboardPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: goToMenu,
            selectedIndex: widget.menu.index,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.check),
                label: 'Tasks'.hardcoded,
              ),
              NavigationDestination(
                icon: const Icon(Icons.people_alt),
                label: 'Team'.hardcoded,
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights),
                label: 'Dashboard'.hardcoded,
              ),
            ],
          ),
        );
      },
    );
  }
}
