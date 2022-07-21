import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class WorkspacePreferencesScreen extends ConsumerWidget {
  final String workspaceId;
  const WorkspacePreferencesScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceValue = ref.watch(workspaceProvider(workspaceId));

    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        data: (workspace) {
          if (workspace == null) {
            return Material(
              child: NotFoundWidget(
                message: 'You do not have access to this workspace. '
                        'Please contact a member to add you to their team'
                    .hardcoded,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text('Preferences'.hardcoded)),
            //! similar with settings screen
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  child: Column(
                    children: [
                      //TODO I din't implement this screen yet because it's gonna be VERY similar with the account screen and that has a lot of stuff to decide yet
                      ListTile(
                        onTap: () =>
                            showNotImplementedAlertDialog(context: context),
                        leading: Avatar.fromWorkspace(workspace),
                        title: Text(workspace.title),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () =>
                            showNotImplementedAlertDialog(context: context),
                        leading: const Icon(Icons.payment),
                        title: Text('Plan'.hardcoded),
                        subtitle: Text(
                            'More features and less limitations'.hardcoded),
                        trailing: Text(
                          'Family'.hardcoded,
                          //TODO setting trailling style
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () => context.goNamed(
                          AppRoute.motivationalMessages.name,
                          params: {'workspaceId': workspace.id},
                        ),
                        leading: const Icon(Icons.message),
                        title: Text('Motivational Messages'.hardcoded),
                        subtitle: Text(
                            'Messages shown when finishing a task'.hardcoded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
