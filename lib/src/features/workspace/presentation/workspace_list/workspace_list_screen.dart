import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'home_bar.dart';
import 'workspace_card.dart';

class WorkspaceListScreen extends ConsumerWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceListValue = ref.watch(workspaceListStreamProvider);
    return Scaffold(
      appBar: const HomeBar(),
      body: AsyncValueWidget<List<Workspace>>(
        value: workspaceListValue,
        data: (workspaceList) => workspaceList.isEmpty
            ? ResponsiveCenter(
                padding: EdgeInsets.all(kSpace * 4),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      'Create your first workspace!'.hardcoded,
                      style: context.textTheme.displaySmall,
                    ),
                    Space(),
                    Text(
                      'A workspace is where you can '
                      'structure a team and manage your tasks.',
                      style: context.textTheme.labelLarge,
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    padding: EdgeInsets.all(kSpace),
                    child: Column(
                      children: [
                        for (final workspace in workspaceList)
                          WorkspaceCard(
                            workspace: workspace,
                            onPressed: () => context.goNamed(
                              AppRoute.workspace.name,
                              params: {'workspaceId': workspace.id},
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.workspaceSetup.name),
        icon: const Icon(Icons.add),
        label: Text('Create new'.hardcoded),
      ),
    );
  }
}
