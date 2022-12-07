import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'avatar/group_avatar.dart';

Future<void> showGroupInfoDialog(
  BuildContext context, {
  required Group group,
}) =>
    showDialog(
      context: context,
      builder: (_) => GroupInfoDialog(group),
    );

class GroupInfoDialog extends StatelessWidget {
  final Group group;
  const GroupInfoDialog(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Space(),
          GroupAvatar(
            group,
            radius: kSpace * 5,
            dialogOnTap: false,
          ),
          Space(2),
          Text(
            group.title,
            style: context.textTheme.titleLarge,
          ),
          if (group.description.isNotEmpty) ...[
            Space(0.5),
            Text(
              group.description,
              style: context.textTheme.bodySmall,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(context.loc.ok),
        ),
      ],
    );
  }
}
