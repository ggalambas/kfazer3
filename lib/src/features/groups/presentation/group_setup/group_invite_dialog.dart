import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/pending_group_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

Future<void> showGroupInviteDialog(
  BuildContext context, {
  required Group group,
}) =>
    showDialog(
      context: context,
      builder: (_) => GroupInviteDialog(group),
    );

class GroupInviteDialog extends ConsumerWidget {
  final Group group;
  const GroupInviteDialog(this.group, {super.key});

  AutoDisposeStateNotifierProvider<PendingGroupController, AsyncValue>
      get groupProvider => pendingGroupControllerProvider(group.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      groupProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(groupProvider);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Space(),
          GroupAvatar(
            group,
            radius: kSpace * 5,
            dialogOnTap: false,
          ),
          Space(2),
          Text(
            '${context.loc.invitedToJoin} ${group.title}',
            style: context.textTheme.titleLarge,
          ),
          if (group.description.isNotEmpty) ...[
            Space(0.5),
            Text(
              group.description,
              style: context.textTheme.bodySmall,
            ),
          ],
        ],
      ),
      actions: [
        LoadingTextButton(
          loading: state.isLoading && state.value == true,
          onPressed: () =>
              ref.read(groupProvider.notifier).declineInvite(group),
          child: Text(context.loc.refuse),
        ),
        LoadingTextButton(
          loading: state.isLoading && state.value == true,
          onPressed: () => ref.read(groupProvider.notifier).acceptInvite(group),
          child: Text(context.loc.accept),
        ),
      ],
    );
  }
}
