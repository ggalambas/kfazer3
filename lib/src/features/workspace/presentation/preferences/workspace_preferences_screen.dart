import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

enum PreferencesMenuOption { delete }

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
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () =>
                      showNotImplementedAlertDialog(context: context),
                  icon: const Icon(Icons.edit),
                ),
                SingleChildMenuButton(
                  onSelected: () =>
                      showNotImplementedAlertDialog(context: context),
                  child: Text('Delete workspace'.hardcoded),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: Avatar.fromWorkspace(workspace),
                        title: Text(workspace.title),
                      ),
                      Text(workspace.description),
                      ListTile(
                        leading: const Icon(Icons.payment),
                        title: Text('Free plan'.hardcoded),
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
