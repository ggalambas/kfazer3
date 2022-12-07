import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import '../group_info_dialog.dart';
import 'avatar.dart';

/// Rounded rectangle avatar with the group image and initials.
class GroupAvatar extends StatelessWidget {
  final Group group;
  final double radius;
  final bool dialogOnTap;

  const GroupAvatar(
    this.group, {
    super.key,
    this.radius = 20,
    this.dialogOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dialogOnTap
          ? () => showDialog(
                context: context,
                builder: (_) => GroupInfoDialog(group),
              )
          : null,
      child: Avatar(
        text: group.name,
        icon: Icons.workspaces,
        radius: radius,
        shape: BoxShape.rectangle,
        foregroundImage:
            group.photoUrl == null ? null : NetworkImage(group.photoUrl!),
      ),
    );
  }
}
