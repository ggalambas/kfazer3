import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/pending_list/pending_group_card.dart';
import 'package:smart_space/smart_space.dart';

class HorizPendingScrollView extends StatelessWidget {
  final List<Group> groups;
  const HorizPendingScrollView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: kSpace),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final group in groups)
              SizedBox(
                width: constraints.maxWidth * 4 / 5,
                child: PendingGroupCard(group),
              ),
          ],
        ),
      );
    });
  }
}
