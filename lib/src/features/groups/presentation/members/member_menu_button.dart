import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum MemberMenuOption with LocalizedEnum {
  turnOwner([MemberRole.admin, MemberRole.member]),
  turnAdmin([MemberRole.member]),
  revokeAdmin([MemberRole.admin]),
  removeMember([MemberRole.admin, MemberRole.member, MemberRole.pending]);

  final List<MemberRole> allowedRoles;
  const MemberMenuOption(this.allowedRoles);

  static List<MemberMenuOption> allowedValues(MemberRole role) =>
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
      case removeMember:
        return context.loc.removeFromGroup;
    }
  }
}

class MemberMenuButton extends StatelessWidget {
  final MemberRole role;
  final void Function(MemberMenuOption option) onOptionSelected;

  const MemberMenuButton({
    super.key,
    required this.role,
    required this.onOptionSelected,
  });

  TextStyle? style(BuildContext context, MemberMenuOption option) {
    switch (option) {
      case MemberMenuOption.removeMember:
        return TextStyle(color: context.colorScheme.error);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuOptions = MemberMenuOption.allowedValues(role);
    return PopupMenuButton<MemberMenuOption>(
      onSelected: (option) => onOptionSelected(option),
      itemBuilder: (context) => [
        for (final option in menuOptions)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: style(context, option),
            ),
          ),
      ],
    );
  }
}
