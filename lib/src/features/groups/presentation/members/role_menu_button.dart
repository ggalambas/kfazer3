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
  final VoidCallback? onTurnOwner;
  final VoidCallback? onTurnAdmin;
  final VoidCallback? onRevokeAdmin;
  final MemberRole role;

  const RoleMenuButton({
    super.key,
    required this.role,
    required this.onTurnOwner,
    required this.onTurnAdmin,
    required this.onRevokeAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final menuOptions = RoleMenuOption.allowedValues(role);
    return PopupMenuButton(
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
      onSelected: (option) {
        switch (option) {
          case RoleMenuOption.turnOwner:
            return onTurnOwner?.call();
          case RoleMenuOption.turnAdmin:
            return onTurnAdmin?.call();
          case RoleMenuOption.revokeAdmin:
            return onRevokeAdmin?.call();
        }
      },
    );
  }
}
