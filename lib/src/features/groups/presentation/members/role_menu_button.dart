import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum RoleMenuOption with LocalizedEnum {
  turnOwner([MemberRole.admin, MemberRole.member]),
  turnAdmin([MemberRole.member]),
  revokeAdmin([MemberRole.admin]);

  final List<MemberRole> allowedRoles;
  const RoleMenuOption(this.allowedRoles);

  static List<RoleMenuOption> allowedValues(MemberRole role) =>
      values.where((option) => option.allowedRoles.contains(role)).toList();

  @override
  String locName(BuildContext context) {
    switch (this) {
      case turnOwner:
        return context.loc.turnOwner;
      case turnAdmin:
        return context.loc.turnAdmin;
      case revokeAdmin:
        return context.loc.revokeAdmin;
    }
  }
}

class RoleMenuButton extends StatelessWidget {
  final void Function(MemberRole role) onRoleChanged;
  final MemberRole role;

  const RoleMenuButton({
    super.key,
    required this.role,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuOptions = RoleMenuOption.allowedValues(role);
    return PopupMenuButton(
      onSelected: (option) => onRoleChanged,
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

class TurnOwnerOption extends StatelessWidget {
  const TurnOwnerOption({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: MemberRole.owner,
      child: Text(
        context.loc.turnOwner,
        style: TextStyle(color: context.colorScheme.primary),
      ),
    );
  }
}

class TurnAdminOption extends StatelessWidget {
  const TurnAdminOption({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: MemberRole.admin,
      child: Text(context.loc.turnAdmin),
    );
  }
}

class RevokeAdminOption extends StatelessWidget {
  const RevokeAdminOption({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: MemberRole.member,
      child: Text(context.loc.revokeAdmin),
    );
  }
}
