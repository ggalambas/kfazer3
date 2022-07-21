import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/invites_page.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/motivation_page.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/pages/workspace_details_page.dart';
import 'package:kfazer3/src/routing/app_router.dart';

/// The three sub-routes that are presented as part of the workspace setup flow.
enum WorkspaceSetupPage {
  details,
  motivation,
  invites;

  WorkspaceSetupPage? get previous {
    final pages =
        WorkspaceSetupPage.values.reversed.skipWhile((page) => this != page);
    return pages.length < 2 ? null : pages.elementAt(1);
  }

  WorkspaceSetupPage? get next {
    final pages = WorkspaceSetupPage.values.skipWhile((page) => this != page);
    return pages.length < 2 ? null : pages.elementAt(1);
  }
}

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
        final previous = widget.page.previous;
        if (previous == null) return true;
        context.goNamed(
          AppRoute.workspaceSetupPage.name,
          params: {'page': previous.name},
        );
        return false;
      },
      child: TapToUnfocus(
        child: Scaffold(
          appBar: AppBar(
            //TODO check how I dealt with the leading hehehe
            actions: [
              //TODO switch for each page
              //? maybe do it on the enum itself, cuz we have a switch in the WillPopScope widget
              //! remove the onSuccess callback from the pages
              //TODO worksapce setup > deal with last page
              TextButton(
                onPressed: () => widget.page.next == null
                    ? showNotImplementedAlertDialog(context: context)
                    : context.goNamed(
                        AppRoute.workspaceSetupPage.name,
                        params: {'page': widget.page.next!.name},
                      ),
                child: const Text('Next'),
              ),
            ],
          ),
          body: PageView(
            // disable swiping between pages
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              WorkspaceDetailsPage(
                onSuccess: () => context.goNamed(
                  AppRoute.workspaceSetupPage.name,
                  params: {'page': WorkspaceSetupPage.motivation.name},
                ),
              ),
              MotivationalMessagesPage(
                onSuccess: () => context.goNamed(
                  AppRoute.workspaceSetupPage.name,
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
