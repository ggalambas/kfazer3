import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import '../../../group/presentation/group_list/home_bar.dart';
import 'workspace_card.dart';

class WorkspaceListScreen extends ConsumerWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceListValue = ref.watch(workspaceListStreamProvider);
    return Scaffold(
      appBar: const HomeBar(),
      body: ResponsiveCenter(
        padding: EdgeInsets.all(kSpace),
        child: AsyncValueWidget<List<Workspace>>(
          value: workspaceListValue,
          data: (workspaceList) => workspaceList.isEmpty
              ? const WorkspaceEmptyList()
              : ListView(
                  children: [
                    for (final workspace in workspaceList)
                      WorkspaceCard(
                        workspace: workspace,
                        onPressed: () => context.goNamed(
                          AppRoute.group.name,
                          params: {'groupId': workspace.id},
                        ),
                      ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.workspaceSetup.name),
        icon: const Icon(Icons.add),
        label: Text(context.loc.createNew),
      ),
    );
  }
}

class WorkspaceEmptyList extends StatelessWidget {
  const WorkspaceEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace * 3),
      child: Column(
        children: [
          const Spacer(),
          Text(
            context.loc.workspaceCreateFirst,
            style: context.textTheme.displaySmall,
          ),
          Space(),
          Text(
            context.loc.workspaceCreateFirstDescription,
            style: context.textTheme.labelLarge,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
