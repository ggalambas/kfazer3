import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/projects/data/projects_repository.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/task_list_page.dart';
import 'package:kfazer3/src/features/team/presentation/team_page.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';

import 'project_bar/project_bar.dart';
import 'project_screen_controller.dart';

/// The three sub-routes that are presented as part of the project screen.
enum ProjectMenu { tasks, team, dashboard }

/// This is the root widget of the project screen, which is composed of 3 pages:
/// 1. Tasks page
/// 2. Team page
/// 3. Dashboard page
///
/// The correct page is displayed (and updated)
/// based on the selected menu
///! The logic for the entire screen is implemented in the
///! [ProjectScreenController],
/// while UI updates are handled by a [PageController].
class ProjectScreen extends ConsumerStatefulWidget {
  final String projectId;
  final ProjectMenu? menu;
  final TaskState? taskState;

  const ProjectScreen({
    super.key,
    required this.projectId,
    this.menu,
    this.taskState,
  });

  @override
  ConsumerState<ProjectScreen> createState() => ProjectScreenState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class ProjectScreenState extends ConsumerState<ProjectScreen>
    with AutomaticKeepAliveClientMixin {
  late var menu = widget.menu ?? ProjectMenu.tasks;
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
  void didUpdateWidget(ProjectScreen oldWidget) {
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
      //   params: {'groupId': widget.projectId},
      //   queryParams: {'menu': ProjectMenu.values[i].name},
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      projectScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    final projectValue = ref.watch(projectStreamProvider(widget.projectId));
    return AsyncValueWidget<Project?>(
      value: projectValue,
      //TODO loading widget
      data: (project) {
        if (project == null) return const NotFoundGroup();
        return Scaffold(
          appBar: ProjectBar(project: project),
          body: PageView(
            controller: controller,
            children: [
              TaskListPage(
                projectId: project.id,
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
