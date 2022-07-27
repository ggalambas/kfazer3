import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_bar/notifications_icon.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_bar/workspace_menu_button.dart';

/// Custom [AppBar] widget that is used by the [WorkspaceScreen].
/// It shows the following actions:
/// - Notifications button
/// - Workspace settings button
/// - Leave workspace button
/// - About workspace button
/// - Archived tasks button
/// - General settings button
///
class WorkspaceBar extends StatelessWidget with PreferredSizeWidget {
  final Workspace workspace;
  const WorkspaceBar({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    // MediaQuery is used on the assumption that the widget takes up the full
    // width of the screen. If that's not the case, LayoutBuilder should be
    // used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(workspace.title),
      centerTitle: screenWidth >= Breakpoint.tablet,
      actions: [
        const NotificationsIcon(),
        WorkspaceMenuButton(workspace: workspace),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
