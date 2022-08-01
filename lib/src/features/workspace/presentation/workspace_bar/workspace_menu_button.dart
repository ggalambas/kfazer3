import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum WorkspaceMenuOption with LocalizedEnum {
  about,
  preferences,
  members,
  archive,
  export,
  leave;

  @override
  String locName(BuildContext context) {
    switch (this) {
      case about:
        return context.loc.about;
      case preferences:
        return context.loc.preferences;
      case members:
        return context.loc.members;
      case archive:
        return context.loc.archive;
      case export:
        return context.loc.export;
      case leave:
        return context.loc.leave;
    }
  }
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
            child: Text(option.locName(context)),
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
            //TODO go to members screen
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.archive:
            context.pushNamed(
              AppRoute.workspaceArchive.name,
              params: {'workspaceId': workspace.id},
            );
            break;
          case WorkspaceMenuOption.export:
            //TODO export workspace
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.leave:
            //TODO leave workspace
            showNotImplementedAlertDialog(context: context);
            break;
        }
      },
    );
  }
}
