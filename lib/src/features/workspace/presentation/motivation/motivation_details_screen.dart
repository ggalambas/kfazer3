import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_details_screen_controller.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

class MotivationDetailsScreen extends ConsumerWidget {
  final String workspaceId;
  const MotivationDetailsScreen({super.key, required this.workspaceId});

  void clearMessages(BuildContext context, Reader read) async {
    final clear = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Clear'.hardcoded,
    );
    if (clear == true) {
      read(motivationDetailsScreenControllerProvider.notifier)
          .clearMessages(workspaceId);
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
    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        data: (workspace) {
          if (workspace == null) return const NotFoundWorkspace();
          return Scaffold(
            appBar: DetailsBar(
              loading: state.isLoading,
              title: 'Motivation'.hardcoded,
              onEdit: () => context.goNamed(
                AppRoute.motivation.name,
                params: {'workspaceId': workspaceId},
                queryParams: {'editing': 'true'},
              ),
              deleteText: 'Clear all'.hardcoded,
              onDelete: () => clearMessages(context, ref.read),
            ),
            body: ResponsiveCenter(
              maxContentWidth: Breakpoint.tablet,
              padding: EdgeInsets.all(kSpace * 2),
              child: ListView(
                children: [
                  for (final message in workspace.motivationalMessages) ...[
                    TextFormField(
                      enabled: false,
                      initialValue: message,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.all(kSpace),
                      ),
                    ),
                    const Divider(),
                  ]
                ],
              ),
            ),
          );
        });
  }
}
