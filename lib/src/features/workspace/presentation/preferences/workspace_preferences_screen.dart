import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class WorkspacePreferencesScreen extends ConsumerWidget {
  final String workspaceId;
  const WorkspacePreferencesScreen({super.key, required this.workspaceId});

  void changePlan(Reader read, Workspace workspace, WorkspacePlan plan) {
    final newWorkspace = workspace.updatePlan(plan);
    read(workspacesRepositoryProvider).updateWorkspace(newWorkspace);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceValue = ref.watch(workspaceStreamProvider(workspaceId));
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      data: (workspace) {
        if (workspace == null) return const NotFoundWorkspace();
        return Scaffold(
          appBar: AppBar(title: Text('Settings'.hardcoded)),
          body: ResponsiveCenter(
            child: ListView(
              children: [
                ListTile(
                  onTap: () => context.goNamed(
                    AppRoute.workspaceDetails.name,
                    params: {'workspaceId': workspace.id},
                  ),
                  leading: Avatar.fromWorkspace(workspace),
                  title: Text(workspace.title),
                ),
                const Divider(),
                SelectionSettingTile<WorkspacePlan>(
                  selected: workspace.plan,
                  onChanged: (plan) => changePlan(ref.read, workspace, plan),
                  options: WorkspacePlan.values,
                  icon: Icons.auto_awesome,
                  title: 'Plan'.hardcoded,
                  description: 'More features and less limitations'.hardcoded,
                ),
                ListTile(
                  onTap: () => context.goNamed(
                    AppRoute.motivation.name,
                    params: {'workspaceId': workspace.id},
                  ),
                  leading: const Icon(Icons.mark_chat_read),
                  title: Text('Motivational Messages'.hardcoded),
                  subtitle:
                      Text('Messages shown when finishing a task'.hardcoded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
