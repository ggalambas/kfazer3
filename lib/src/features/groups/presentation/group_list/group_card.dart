import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/group_menu_button.dart';
import 'package:kfazer3/src/features/projects/application/projects_service.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';
import 'package:kfazer3/src/features/projects/presentation/project_card.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single group inside a card.
class GroupCard extends StatelessWidget {
  final Group group;
  const GroupCard(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: kSpace * 1.5,
        vertical: kSpace * 0.75,
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.all(kSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: GroupAvatar(group),
              title: Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(height: 1.1),
              ),
              trailing: GroupMenuButton(group: group),
            ),
            ProjectList(groupId: group.id),
            TextButton.icon(
              onPressed: () => showNotImplementedAlertDialog(context: context),
              icon: const Icon(Icons.add),
              label: Text(context.loc.newProject),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO to this abstraction? if yes, where should this be put
class ProjectList extends ConsumerWidget {
  final GroupId groupId;
  const ProjectList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsValue = ref.watch(projectListStreamProvider(groupId));
    return AsyncValueWidget<List<Project>>(
      value: projectsValue,
      data: (projects) {
        return Column(
          children: [for (final project in projects) ProjectCard(project)],
        );
      },
    );
  }
}
