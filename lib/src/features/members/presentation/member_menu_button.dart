import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'member_menu_option.dart';

class MemberMenuButton extends StatelessWidget {
  final MemberRole editorRole;
  final MemberRole targetRole;
  final void Function(MemberMenuOption option) onOptionSelected;

  const MemberMenuButton({
    super.key,
    required this.editorRole,
    required this.targetRole,
    required this.onOptionSelected,
  });

  TextStyle? style(BuildContext context, MemberMenuOption option) {
    switch (option) {
      case MemberMenuOption.removeMember:
      case MemberMenuOption.removeInvite:
        return TextStyle(color: context.colorScheme.error);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuOptions = MemberMenuOption.allowedValues(editorRole, targetRole);
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
