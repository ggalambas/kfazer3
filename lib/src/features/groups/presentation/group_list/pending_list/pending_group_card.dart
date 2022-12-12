import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'pending_group_controller.dart';

/// Used to show a single pending group inside a card.
class PendingGroupCard extends ConsumerWidget {
  final Group group;
  const PendingGroupCard(this.group, {super.key});

  AutoDisposeStateNotifierProvider<PendingGroupController, AsyncValue>
      get groupProvider => pendingGroupControllerProvider(group.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      groupProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(groupProvider);
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.all(kSpace),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(right: kSpace),
              leading: GroupAvatar(group),
              title: Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(height: 1.1),
              ),
              trailing: Text(
                'Thu, sep 19', //TODO group.inviteDate
                style: context.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSpace / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (group.description.isNotEmpty)
                    ExpandableText(
                      group.description,
                      style: context.textTheme.bodySmall,
                      expandText: context.loc.showMore,
                      collapseText: context.loc.showLess,
                      expandOnTextTap: true,
                      collapseOnTextTap: true,
                      animation: true,
                      maxLines: 2,
                      linkEllipsis: false,
                      linkColor: context.colorScheme.primary,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LoadingTextButton(
                        loading: state.isLoading && state.value == true,
                        onPressed: () => ref
                            .read(groupProvider.notifier)
                            .declineInvite(group),
                        child: Text(context.loc.refuse),
                      ),
                      LoadingTextButton(
                        loading: state.isLoading && state.value == true,
                        onPressed: () => ref
                            .read(groupProvider.notifier)
                            .acceptInvite(group),
                        child: Text(context.loc.accept),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
