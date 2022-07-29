import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum WorkspaceMenuOption {
  about,
  preferences,
  members,
  archive,
  export,
  leave,
}

class WorkspaceMenuButton extends ConsumerWidget {
  final Workspace workspace;
  const WorkspaceMenuButton({super.key, required this.workspace});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in WorkspaceMenuOption.values)
          PopupMenuItem(
            value: option,
            child: Text(option.name.hardcoded),
          ),
      ],
      onSelected: (option) {
        switch (option) {
          case WorkspaceMenuOption.about:
            showAlertDialog(
              context: context,
              title: workspace.title,
              content: workspace.description,
            );
            break;
          case WorkspaceMenuOption.preferences:
            context.pushNamed(
              AppRoute.workspacePreferences.name,
              params: {'workspaceId': workspace.id},
            );
            break;
          case WorkspaceMenuOption.members:
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.archive:
            context.pushNamed(
              AppRoute.workspaceArchive.name,
              params: {'workspaceId': workspace.id},
            );
            break;
          case WorkspaceMenuOption.export:
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.leave:
            ref.read(settingsRepositoryProvider).removeLastWorkspaceId();
            showNotImplementedAlertDialog(context: context);
            break;
        }
      },
    );
  }
}
