import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum WorkspaceMenuOption { about, archive, preferences, leave }

class WorkspaceMenuButton extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceMenuButton({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (option) {
        switch (option) {
          case WorkspaceMenuOption.about:
            showAlertDialog(
              context: context,
              title: workspace.title,
              content: workspace.description,
            );
            break;
          case WorkspaceMenuOption.archive:
            context.goNamed(
              AppRoute.workspaceArchive.name,
              params: {'workspaceId': workspace.id},
            );
            break;
          case WorkspaceMenuOption.preferences:
            context.goNamed(
              AppRoute.workspacePreferences.name,
              params: {'workspaceId': workspace.id},
            );
            break;
          case WorkspaceMenuOption.leave:
            showNotImplementedAlertDialog(context: context);
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: WorkspaceMenuOption.about,
          child: Text('About'.hardcoded),
        ),
        PopupMenuItem(
          value: WorkspaceMenuOption.archive,
          child: Text('Archive'.hardcoded),
        ),
        PopupMenuItem(
          value: WorkspaceMenuOption.preferences,
          child: Text('Preferences'.hardcoded),
        ),
        PopupMenuItem(
          value: WorkspaceMenuOption.leave,
          child: Text('Leave'.hardcoded),
        ),
      ],
    );
  }
}
