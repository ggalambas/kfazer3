import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/group_info_dialog.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'group_list_controller.dart';

enum GroupMenuOption with LocalizedEnum {
  about(MemberRole.values),
  preferences([MemberRole.owner, MemberRole.admin]),
  members(MemberRole.values),
  archive(MemberRole.values),
  export(MemberRole.values),
  leave([MemberRole.admin, MemberRole.member]);

  final List<MemberRole> allowedRoles;
  const GroupMenuOption(this.allowedRoles);

  static List<GroupMenuOption> allowedValues(MemberRole role) =>
      values.where((option) => option.allowedRoles.contains(role)).toList();

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

//TODO change to stateless when context has a mounted property (future flutter version)
class GroupMenuButton extends ConsumerStatefulWidget {
  final Group group;
  const GroupMenuButton({super.key, required this.group});

  @override
  ConsumerState<GroupMenuButton> createState() => _GroupMenuButtonState();
}

class _GroupMenuButtonState extends ConsumerState<GroupMenuButton> {
  @override
  Widget build(BuildContext context) {
    final menuOptions = GroupMenuOption.allowedValues(
      ref.read(roleProvider(widget.group)),
    );
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in menuOptions)
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
          case GroupMenuOption.preferences:
            return context.pushNamed(
              AppRoute.groupPreferences.name,
              params: {'groupId': widget.group.id},
            );
          case GroupMenuOption.members:
            return context.pushNamed(
              AppRoute.groupMembers.name,
              params: {'groupId': widget.group.id},
            );
          case GroupMenuOption.archive:
            //TODO navigate to group archive (after project)
            return showNotImplementedAlertDialog(context: context);
          case GroupMenuOption.export:
            //TODO export group (after export project)
            return showNotImplementedAlertDialog(context: context);
          case GroupMenuOption.leave:
            return showLoadingDialog(
              context: context,
              title: context.loc.areYouSure,
              cancelActionText: context.loc.cancel,
              defaultActionText: context.loc.leave,
              onDefaultAction: () async {
                final success = await ref
                    .read(groupListControllerProvider.notifier)
                    .leaveGroup(widget.group);
                if (mounted && success) Navigator.of(context).pop();
              },
            );
        }
      },
    );
  }
}
