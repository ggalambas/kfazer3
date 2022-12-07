import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/group_menu_button.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single group inside a card.
class GroupCard extends StatelessWidget {
  final Group group;
  const GroupCard(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSpace),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: EdgeInsets.all(kSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GroupAvatar(group),
                title: Text(group.name),
                trailing: GroupMenuButton(group: group),
              ),
              //TODO projects list
              TextButton.icon(
                onPressed: () =>
                    showNotImplementedAlertDialog(context: context),
                icon: const Icon(Icons.add),
                label: Text(context.loc.newProject),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
