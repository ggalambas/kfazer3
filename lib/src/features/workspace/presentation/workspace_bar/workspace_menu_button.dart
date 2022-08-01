import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum WorkspaceMenuOption {
  about,
  preferences,
  members,
  archive,
  export,
  leave,
}

class WorkspaceMenuButton extends ConsumerStatefulWidget {
  final Workspace workspace;
  const WorkspaceMenuButton({super.key, required this.workspace});

  @override
  ConsumerState<WorkspaceMenuButton> createState() =>
      _WorkspaceMenuButtonState();
}

class _WorkspaceMenuButtonState extends ConsumerState<WorkspaceMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in WorkspaceMenuOption.values)
          PopupMenuItem(
            value: option,
            child: Text(
              option.name.hardcoded,
              style: option == WorkspaceMenuOption.leave
                  ? TextStyle(color: context.colorScheme.error)
                  : null,
            ),
          ),
      ],
      onSelected: (option) {
        switch (option) {
          case WorkspaceMenuOption.about:
            showAlertDialog(
              context: context,
              title: widget.workspace.title,
              content: widget.workspace.description,
            );
            break;
          case WorkspaceMenuOption.preferences:
            context.pushNamed(
              AppRoute.workspacePreferences.name,
              params: {'workspaceId': widget.workspace.id},
            );
            break;
          case WorkspaceMenuOption.members:
            //TODO go to members screen
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.archive:
            context.pushNamed(
              AppRoute.workspaceArchive.name,
              params: {'workspaceId': widget.workspace.id},
            );
            break;
          case WorkspaceMenuOption.export:
            //TODO export workspace
            showNotImplementedAlertDialog(context: context);
            break;
          case WorkspaceMenuOption.leave:
            showLoadingDialog(
              context: context,
              title: 'Are you sure'.hardcoded,
              cancelActionText: 'Cancel'.hardcoded,
              defaultActionText: 'Leave'.hardcoded,
              onDefaultAction: () async {
                final success = await ref
                    .read(workspaceScreenControllerProvider.notifier)
                    .leave(widget.workspace);
                if (mounted && success) context.goNamed(AppRoute.home.name);
              },
            );
            break;
        }
      },
    );
  }
}
