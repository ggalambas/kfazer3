import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'group_setup_controller.dart';
import 'pages/group_details_page.dart';
import 'pages/invites_page.dart';
import 'pages/motivation_page.dart';

/// The three sub-routes that are presented as part of the group setup flow.
enum GroupSetupPage with LocalizedEnum {
  details,
  motivation,
  invites;

  GroupSetupPage? get previous {
    final i = index - 1;
    return i < 0 ? null : GroupSetupPage.values[i];
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

/// This is the root widget of the group setup flow, which is composed of 3 pages:
/// 1. Group details page
/// 2. Motivation page
/// 3. Invites page
///
///! The logic for the entire flow is implemented in the [GroupSetupScreenController],
/// while UI updates are handled by a [PageController].
class GroupSetupScreen extends ConsumerStatefulWidget {
  final GroupSetupPage page;
  const GroupSetupScreen({super.key, required this.page});

  @override
  ConsumerState<GroupSetupScreen> createState() => GroupSetupScreenState();
}

class GroupSetupScreenState extends ConsumerState<GroupSetupScreen> {
  late final controller = PageController(initialPage: widget.page.index);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GroupSetupScreen oldWidget) {
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
    ref.listen<AsyncValue>(
      groupSetupControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    // Note: only the currently active page will be visible.
    return WillPopScope(
      onWillPop: () async {
        final previous = widget.page.previous;
        if (previous == null) return true;
        context.goNamed(
          AppRoute.groupSetupPage.name,
          params: {'page': previous.name},
        );
        return false;
      },
      child: TapToUnfocus(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.page.locName(context)),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kSpace * 2),
                child: TextButton(
                  onPressed: () => context.goNamed(AppRoute.home.name),
                  child: Text(context.loc.cancel),
                ),
              ),
            ],
          ),
          body: PageView(
            // disable swiping between pages
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              GroupDetailsPage(
                onSuccess: () => context.goNamed(
                  AppRoute.groupSetupPage.name,
                  params: {'page': GroupSetupPage.motivation.name},
                ),
              ),
              MotivationPage(
                onSuccess: () => context.goNamed(
                  AppRoute.groupSetupPage.name,
                  params: {'page': GroupSetupPage.invites.name},
                ),
              ),
              InvitesPage(
                onSuccess: () async {
                  final groupId = await ref
                      .read(groupSetupControllerProvider.notifier)
                      .createGroup();
                  if (groupId != null && mounted) {
                    context.goNamed(AppRoute.home.name);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
