import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/create_workspace_fab.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/home_bar.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/workspace_card.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

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
            ? EmptyPlaceholder(
                message: 'You have no workspaces'.hardcoded,
                illustration: UnDrawIllustration.building,
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
      floatingActionButton: const CreateWorkspaceFab(),
    );
  }
}
