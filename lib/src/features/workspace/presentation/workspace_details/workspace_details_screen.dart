import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'workspace_details_screen_controller.dart';

class WorkspaceDetailsScreen extends ConsumerWidget {
  final String workspaceId;
  const WorkspaceDetailsScreen({super.key, required this.workspaceId});

  void deleteWorkspace(BuildContext context, Reader read) async {
    final delete = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Delete'.hardcoded,
    );
    if (delete == true) {
      read(workspaceDetailsScreenControllerProvider.notifier)
          .deleteWorkspace(workspaceId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      workspaceDetailsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final workspaceValue = ref.watch(workspaceStreamProvider(workspaceId));
    final state = ref.watch(workspaceDetailsScreenControllerProvider);
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      data: (workspace) {
        if (workspace == null) return const NotFoundWorkspace();
        return Scaffold(
          appBar: DetailsBar(
            loading: state.isLoading,
            title: 'Workspace'.hardcoded,
            onEdit: () => context.goNamed(
              AppRoute.workspaceDetails.name,
              params: {'workspaceId': workspaceId},
              queryParams: {'editing': 'true'},
            ),
            deleteText: 'Delete workspace'.hardcoded,
            onDelete: () => deleteWorkspace(context, ref.read),
          ),
          body: SingleChildScrollView(
            child: ResponsiveCenter(
              maxContentWidth: Breakpoint.tablet,
              padding: EdgeInsets.all(kSpace * 2),
              child: Column(
                children: [
                  Avatar.fromWorkspace(workspace, radius: kSpace * 10),
                  Space(4),
                  TextFormField(
                    enabled: false,
                    initialValue: workspace.title,
                    decoration: InputDecoration(
                      labelText: 'Title'.hardcoded,
                    ),
                  ),
                  Space(),
                  TextFormField(
                    enabled: false,
                    initialValue: workspace.description,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Description'.hardcoded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
