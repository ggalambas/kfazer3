import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'avatar/group_avatar.dart';

class GroupInfoDialog extends ConsumerWidget {
  final Group group;
  const GroupInfoDialog(this.group, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
