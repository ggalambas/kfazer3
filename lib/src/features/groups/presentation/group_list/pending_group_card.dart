import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single group inside a card.
class PendingGroupCard extends StatelessWidget {
  final Group group;
  const PendingGroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.all(kSpace),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: GroupAvatar(group),
              title: Text(group.title),
              trailing: IconButton(
                iconSize: kSmallIconSize,
                //TODO reject group invite
                onPressed: () =>
                    showNotImplementedAlertDialog(context: context),
                icon: const Icon(Icons.close),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSpace / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (group.description.isNotEmpty)
                    ExpandableText(
                      group.description,
                      style: context.textTheme.bodySmall,
                      expandText: 'show more',
                      collapseText: 'show less',
                      expandOnTextTap: true,
                      collapseOnTextTap: true,
                      animation: true,
                      maxLines: 2,
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      //TODO accept group invite
                      onPressed: () =>
                          showNotImplementedAlertDialog(context: context),
                      child: Text('Accept'.hardcoded),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The loading widget for [PendingGroupCard].
class LoadingPendingGroupCard extends StatelessWidget {
  const LoadingPendingGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(kSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(),
            TextButton(onPressed: null, child: SizedBox()),
          ],
        ),
      ),
    ).loader(context);
  }
}
