import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single workspace inside a card.
class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  final VoidCallback onPressed;

  const WorkspaceCard({
    super.key,
    required this.workspace,
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
          child: Row(
            children: [
              Avatar.fromWorkspace(workspace),
              Space(2),
              Text(workspace.title),
            ],
          ),
        ),
      ),
    );
  }
}
