import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_details_screen_controller.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

class MotivationDetailsScreen extends ConsumerWidget {
  final String workspaceId;
  const MotivationDetailsScreen({super.key, required this.workspaceId});

  void clearMessages(
      BuildContext context, Reader read, Workspace workspace) async {
    final clear = await showAlertDialog(
      context: context,
      title: context.loc.areYouSure,
      cancelActionText: context.loc.cancel,
      defaultActionText: context.loc.clear,
    );
    if (clear == true) {
      read(motivationDetailsScreenControllerProvider.notifier)
          .clearMessages(workspace);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      motivationDetailsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final workspaceValue = ref.watch(workspaceStreamProvider(workspaceId));
    final state = ref.watch(motivationDetailsScreenControllerProvider);
    //TODO empty motivation screen
    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        //TODO loading widget
        data: (workspace) {
          if (workspace == null) return const NotFoundGroup();
          return Scaffold(
            appBar: DetailsBar(
              loading: state.isLoading,
              title: context.loc.motivation,
              onEdit: () => context.goNamed(
                AppRoute.motivation.name,
                params: {'groupId': workspaceId},
                queryParams: {'editing': 'true'},
              ),
              deleteText: context.loc.clearAll,
              onDelete: () => clearMessages(context, ref.read, workspace),
            ),
            body: ResponsiveCenter(
              maxContentWidth: Breakpoint.tablet,
              padding: EdgeInsets.all(kSpace * 2),
              child: ListView.separated(
                itemCount: workspace.motivationalMessages.length,
                separatorBuilder: (context, i) => const Divider(),
                itemBuilder: (context, i) => TextFormField(
                  enabled: false,
                  initialValue: workspace.motivationalMessages[i],
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.all(kSpace),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
