import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/preferences/motivational_messages_controller.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class MotivationalMessagesScreen extends ConsumerWidget {
  final String workspaceId;
  const MotivationalMessagesScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceValue = ref.watch(workspaceStreamProvider(workspaceId));
    final editState = ref.watch(motivationalMessagesControllerProvider);
    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        data: (workspace) {
          if (workspace == null) return const NotFoundWorkspace();
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (editState.value)
                  LoadingTextButton(
                    loading: editState.isLoading,
                    onPressed: ref
                        .read(motivationalMessagesControllerProvider.notifier)
                        .save,
                    child: Text('Save'.hardcoded),
                  )
                else ...[
                  IconButton(
                    tooltip: 'Edit'.hardcoded,
                    onPressed: ref
                        .read(motivationalMessagesControllerProvider.notifier)
                        .edit,
                    icon: const Icon(Icons.edit),
                  ),
                  SingleChildMenuButton(
                    onSelected: () =>
                        showNotImplementedAlertDialog(context: context),
                    child: Text('Clear all'.hardcoded),
                  ),
                ],
              ],
            ),
            body: CustomScrollView(
              slivers: [
                ResponsiveSliverCenter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //TODO add a widget with an explanation
                      //? maybe use the same 'two columns' ui from the sign in
                      for (final message in workspace.motivationalMessages)
                        ListTile(
                          title: Text(message),
                          trailing: editState.value
                              ? IconButton(
                                  tooltip: 'Remove'.hardcoded,
                                  onPressed: () =>
                                      showNotImplementedAlertDialog(
                                          context: context),
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showNotImplementedAlertDialog(context: context),
              icon: const Icon(Icons.add),
              label: Text('Add new'.hardcoded),
            ),
          );
        });
  }
}
