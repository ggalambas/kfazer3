import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';
import 'package:smart_space/smart_space.dart';

import 'pending_group_controller.dart';

/// Used to show a single pending group inside a card.
class PendingGroupCard extends ConsumerWidget {
  final Group group;
  const PendingGroupCard({super.key, required this.group});

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
              contentPadding: EdgeInsets.zero,
              leading: GroupAvatar(group),
              title: Text(group.title),
              trailing: LoadingIconButton(
                iconSize: kSmallIconSize,
                loading: state.isLoading && state.value == false,
                onPressed: state.isLoading
                    ? null
                    : () =>
                        ref.read(groupProvider.notifier).declineInvite(group),
                icon: const Icon(Icons.close),
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
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LoadingTextButton(
                      loading: state.isLoading && state.value == true,
                      onPressed: state.isLoading
                          ? null
                          : () => ref
                              .read(groupProvider.notifier)
                              .acceptInvite(group),
                      child: Text(context.loc.accept),
                    ),
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

/// The loading widget for [PendingGroupCard].
class LoadingPendingGroupCard extends StatelessWidget {
  const LoadingPendingGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(kSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(),
            TextButton(onPressed: null, child: SizedBox()),
          ],
        ),
      ),
    ).loader(context);
  }
}
