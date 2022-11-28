import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

//TODO task activity screen web

class TaskActivityScreen extends ConsumerWidget {
  final String taskId;
  const TaskActivityScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO get participanting users
    final user = ref.watch(currentUserStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.activity)),
      body: ListView(
        children: [
          for (var i = 0; i < 3; i++)
            ListTile(
              dense: true,
              leading: UserAvatar(user),
              title: Text(
                user.name,
                style: context.textTheme.bodySmall,
              ),
              subtitle: Text(
                'Marked the task as completed'.hardcoded,
                style: context.textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
