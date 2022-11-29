import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'create_group_button.dart';

class GroupEmptyList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const GroupEmptyList({super.key, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding.add(EdgeInsets.all(kSpace * 3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.groupCreateFirst,
            // '',
            style: context.textTheme.displaySmall,
          ),
          Space(),
          Text(
            context.loc.groupCreateFirstDescription,
            // '',
            style: context.textTheme.labelLarge,
          ),
          Space(3),
          const Center(child: CreateGroupButton.elevated()),
        ],
      ),
    );
  }
}
