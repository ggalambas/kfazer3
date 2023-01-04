import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single project inside a card.
class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard(this.project, {super.key});

  //TODO on pressed
  //TODO a 'more' button?

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: context.colorScheme.surfaceVariant.withOpacity(0.6),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: kSpace * 1.5),
        title: Text(
          project.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(height: 1.1),
        ),
        // trailing: GroupMenuButton(group: group),
      ),
    );
  }
}
