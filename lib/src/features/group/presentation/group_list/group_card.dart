import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single group inside a card.
class GroupCard extends StatelessWidget {
  final Workspace group; //!
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
          child: Row(
            children: [
              Avatar.fromWorkspace(group), //!
              Space(2),
              Text(group.title),
            ],
          ),
        ),
      ),
    );
  }
}
