import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/invites_page.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/motivation_page.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/workspace_details_page.dart';
import 'package:kfazer3/src/routing/app_router.dart';

/// The three sub-routes that are presented as part of the workspace setup flow.
enum WorkspaceSetupPage { details, motivation, invites }

/// This is the root widget of the workspace setup flow, which is composed of 3 pages:
/// 1. Workspace details page
/// 2. Motivation page
/// 3. Invites page
///
///! The logic for the entire flow is implemented in the [WorkspaceSetupScreenController],
/// while UI updates are handled by a [PageController].
class WorkspaceSetupScreen extends ConsumerStatefulWidget {
  final WorkspaceSetupPage page;
  const WorkspaceSetupScreen({super.key, required this.page});

  @override
  ConsumerState<WorkspaceSetupScreen> createState() =>
      _WorkspaceSetupScreenState();
}

class _WorkspaceSetupScreenState extends ConsumerState<WorkspaceSetupScreen> {
  late final controller = PageController(initialPage: widget.page.index);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WorkspaceSetupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // perform a nice scroll animation to reveal the next page
    if (controller.hasClients && controller.position.hasViewportDimension) {
      controller.animateToPage(
        widget.page.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue>(
    //   workspaceSetupControllerProvider,
    //   (_, state) => state.showAlertDialogOnError(context),
    // );
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    // Note: only the currently active page will be visible.
    return WillPopScope(
      onWillPop: () async {
        switch (widget.page) {
          case WorkspaceSetupPage.details:
            return true;
          case WorkspaceSetupPage.motivation:
            context.goNamed(
              AppRoute.workspaceSetup.name,
              params: {'page': WorkspaceSetupPage.details.name},
            );
            return false;
          case WorkspaceSetupPage.invites:
            context.goNamed(
              AppRoute.workspaceSetup.name,
              params: {'page': WorkspaceSetupPage.motivation.name},
            );
            return false;
        }
      },
      child: TapToUnfocus(
        child: Scaffold(
          body: PageView(
            // disable swiping between pages
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              WorkspaceDetailsPage(
                onSuccess: () => context.goNamed(
                  AppRoute.workspaceSetup.name,
                  params: {'page': WorkspaceSetupPage.motivation.name},
                ),
              ),
              MotivationalMessagesPage(
                onSuccess: () => context.goNamed(
                  AppRoute.workspaceSetup.name,
                  params: {'page': WorkspaceSetupPage.invites.name},
                ),
              ),
              InvitesPage(
                onSuccess: (workspaceId) => context.goNamed(
                  AppRoute.workspace.name,
                  params: {'workspaceId': workspaceId},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
