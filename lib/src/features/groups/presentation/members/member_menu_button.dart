import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'member_menu_option.dart';

class MemberMenuButton extends StatelessWidget {
  final List<MemberMenuOption> options;
  final void Function(MemberMenuOption option) onOptionSelected;

  const MemberMenuButton({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  TextStyle? textStyle(BuildContext context, MemberMenuOption option) {
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
    return PopupMenuButton<MemberMenuOption>(
      onSelected: (option) => onOptionSelected(option),
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: textStyle(context, option),
            ),
          ),
      ],
    );
  }
}
