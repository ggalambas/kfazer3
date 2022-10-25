import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class SliverTaskHeader extends StatelessWidget {
  final Task task;
  const SliverTaskHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: kSpace,
        horizontal: kSpace * 2,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Text(
            task.description,
            style: context.textTheme.headlineSmall,
          ),
          Space(),
          Text(
            '${task.startDate} - ${task.dueDate}',
            style: context.textTheme.bodySmall,
          ),
        ]),
      ),
    );
  }
}
