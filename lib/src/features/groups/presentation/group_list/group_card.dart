import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/group_menu_button.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single group inside a card.
class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onPressed;

  const GroupCard({
    super.key,
    required this.group,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(kSpace),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Avatar.fromGroup(group),
            title: Text(group.title),
            trailing: GroupMenuButton(group: group),
          ),
        ),
      ),
    );
  }
}
