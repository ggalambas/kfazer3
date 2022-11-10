import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/group_info_dialog.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum GroupMenuOption with LocalizedEnum {
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

class GroupMenuButton extends ConsumerStatefulWidget {
  final Group group;
  const GroupMenuButton({super.key, required this.group});

  @override
  ConsumerState<GroupMenuButton> createState() => _GroupMenuButtonState();
}

class _GroupMenuButtonState extends ConsumerState<GroupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in GroupMenuOption.values)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: option == GroupMenuOption.leave
                  ? TextStyle(color: context.colorScheme.error)
                  : null,
            ),
          ),
      ],
      onSelected: (option) {
        switch (option) {
          case GroupMenuOption.about:
            showDialog(
              context: context,
              builder: (_) => GroupInfoDialog(widget.group),
            );
            break;
          //TODO only show for admins
          //TODO navigate to group preferences
          case GroupMenuOption.preferences:
            context.pushNamed(
              AppRoute.workspacePreferences.name,
              params: {'groupId': widget.group.id},
            );
            break;
          case GroupMenuOption.members:
            //TODO go to members screen
            showNotImplementedAlertDialog(context: context);
            break;
          //TODO navigate to group archive
          case GroupMenuOption.archive:
            context.pushNamed(
              AppRoute.workspaceArchive.name,
              params: {'groupId': widget.group.id},
            );
            break;
          case GroupMenuOption.export:
            //TODO export group
            showNotImplementedAlertDialog(context: context);
            break;
          case GroupMenuOption.leave:
            //TODO don't show for owner
            //TODO change logic for group
            showLoadingDialog(
              context: context,
              title: 'Are you sure'.hardcoded,
              cancelActionText: 'Cancel'.hardcoded,
              defaultActionText: 'Leave'.hardcoded,
              onDefaultAction: () async {
                final success = await ref
                    .read(workspaceScreenControllerProvider.notifier)
                    .leave(widget.group.id);
                if (mounted && success) context.goNamed(AppRoute.home.name);
              },
            );
            break;
        }
      },
    );
  }
}
