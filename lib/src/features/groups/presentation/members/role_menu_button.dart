import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum RoleMenuOption with LocalizedEnum {
  turnOwner([MemberRole.admin, MemberRole.member]),
  turnAdmin([MemberRole.member]),
  revokeAdmin([MemberRole.admin]),
  removeMember([MemberRole.admin, MemberRole.member, MemberRole.pending]);

  final List<MemberRole> allowedRoles;
  const RoleMenuOption(this.allowedRoles);

  static List<RoleMenuOption> allowedValues(MemberRole role) =>
      values.where((option) => option.allowedRoles.contains(role)).toList();

  MemberRole? get newRole {
    switch (this) {
      case turnOwner:
        return MemberRole.owner;
      case turnAdmin:
        return MemberRole.admin;
      case revokeAdmin:
        return MemberRole.member;
      case removeMember:
        return null;
    }
  }

  @override
  String locName(BuildContext context) {
    switch (this) {
      case turnOwner:
        return context.loc.turnOwner;
      case turnAdmin:
        return context.loc.turnAdmin;
      case revokeAdmin:
        return context.loc.revokeAdmin;
      case removeMember:
        return 'Remove from group'.hardcoded;
    }
  }
}

class RoleMenuButton extends StatelessWidget {
  final MemberRole role;
  final void Function(MemberRole? role) onRoleChanged;

  const RoleMenuButton({
    super.key,
    required this.role,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuOptions = RoleMenuOption.allowedValues(role);
    return PopupMenuButton<RoleMenuOption>(
      onSelected: (option) => onRoleChanged(option.newRole),
      itemBuilder: (context) => [
        for (final option in menuOptions)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: option == RoleMenuOption.turnOwner
                  ? TextStyle(color: context.colorScheme.primary)
                  : null,
            ),
          ),
      ],
    );
  }
}
