import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'workspace_details_screen_controller.dart';

class WorkspaceDetailsScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const WorkspaceDetailsScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<WorkspaceDetailsScreen> createState() =>
      _WorkspaceDetailsScreenState();
}

class _WorkspaceDetailsScreenState
    extends ConsumerState<WorkspaceDetailsScreen> {
  void deleteWorkspace(Workspace workspace) => showLoadingDialog(
        context: context,
        title: context.loc.areYouSure,
        cancelActionText: context.loc.cancel,
        defaultActionText: context.loc.delete,
        onDefaultAction: () async {
          final success = await ref
              .read(workspaceDetailsScreenControllerProvider.notifier)
              .deleteWorkspace(widget.workspaceId);
          if (mounted && success) context.goNamed(AppRoute.home.name);
        },
      );

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      workspaceDetailsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final workspaceValue =
        ref.watch(workspaceStreamProvider(widget.workspaceId));
    final state = ref.watch(workspaceDetailsScreenControllerProvider);
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      data: (workspace) {
        if (workspace == null) return const NotFoundWorkspace();
        return Scaffold(
          appBar: DetailsBar(
            loading: state.isLoading,
            title: context.loc.workspace,
            onEdit: () => context.goNamed(
              AppRoute.workspaceDetails.name,
              params: {'workspaceId': widget.workspaceId},
              queryParams: {'editing': 'true'},
            ),
            deleteText: context.loc.deleteWorkspace,
            //TODO only show for creator
            onDelete: () => deleteWorkspace(workspace),
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
                      labelText: context.loc.title,
                    ),
                  ),
                  Space(),
                  TextFormField(
                    enabled: false,
                    initialValue: workspace.description,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: context.loc.description,
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
