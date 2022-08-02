import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';

import 'pages/invites_page.dart';
import 'pages/motivation_page.dart';
import 'pages/workspace_details_page.dart';

/// The three sub-routes that are presented as part of the workspace setup flow.
enum WorkspaceSetupPage with LocalizedEnum {
  details,
  motivation,
  invites;

  WorkspaceSetupPage? get previous {
    final i = index - 1;
    return i < 0 ? null : WorkspaceSetupPage.values[i];
  }

  WorkspaceSetupPage? get next {
    final i = index + 1;
    return i >= WorkspaceSetupPage.values.length
        ? null
        : WorkspaceSetupPage.values[i];
  }

  @override
  String locName(BuildContext context) {
    switch (this) {
      case details:
        return context.loc.details;
      case motivation:
        return context.loc.motivation;
      case invites:
        return context.loc.invites;
    }
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
            title: Text(widget.page.locName(context)),
            actions: [
              TextButton(
                onPressed: () => context.goNamed(AppRoute.home.name),
                child: Text(context.loc.cancel),
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
              MotivationPage(
                onSuccess: () => context.goNamed(
                  AppRoute.workspaceSetupPage.name,
                  params: {'page': WorkspaceSetupPage.invites.name},
                ),
              ),
              const InvitesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
