import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_button.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

import 'project_menu_button.dart';

/// Custom [AppBar] widget that is used by the [ProjectScreen].
/// It shows the following actions:
/// - Notifications button
/// - Project settings button
/// - Leave project button
/// - About project button
/// - Archived tasks button
/// - General settings button
///
class ProjectBar extends StatelessWidget with PreferredSizeWidget {
  final Project project;
  const ProjectBar({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // MediaQuery is used on the assumption that the widget takes up the full
    // width of the screen. If that's not the case, LayoutBuilder should be
    // used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(project.title),
      centerTitle: screenWidth >= Breakpoint.tablet,
      actions: [
        const NotificationsIconButton(),
        ProjectMenuButton(project: project),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
