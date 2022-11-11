import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/group_info_dialog.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'group_menu_controller.dart';

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
    ref.listen<AsyncValue>(
      groupMenuControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
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
      onSelected: (option) async {
        switch (option) {
          case GroupMenuOption.about:
            return showDialog(
              context: context,
              builder: (_) => GroupInfoDialog(widget.group),
            );
          //TODO only show for admins
          case GroupMenuOption.preferences:
            return context.pushNamed(
              AppRoute.groupPreferences.name,
              params: {'groupId': widget.group.id},
            );
          case GroupMenuOption.members:
            //TODO go to members screen
            return showNotImplementedAlertDialog(context: context);
          //TODO navigate to group archive
          case GroupMenuOption.archive:
            return context.pushNamed(
              AppRoute.workspaceArchive.name,
              params: {'groupId': widget.group.id},
            );
          case GroupMenuOption.export:
            //TODO export group
            return showNotImplementedAlertDialog(context: context);
          case GroupMenuOption.leave:
            //TODO don't show for owner
            return showLoadingDialog(
              context: context,
              title: context.loc.areYouSure,
              cancelActionText: context.loc.cancel,
              defaultActionText: context.loc.leave,
              onDefaultAction: () async {
                await ref
                    .read(groupMenuControllerProvider.notifier)
                    .leaveGroup(widget.group);
                if (mounted) Navigator.of(context).pop();
              },
            );
        }
      },
    );
  }
}
