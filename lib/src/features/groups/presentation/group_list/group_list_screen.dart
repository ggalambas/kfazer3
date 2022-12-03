import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/group_list_title.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/horizontal_pending_view.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'create_group_button.dart';
import 'empty_group_list.dart';
import 'group_card.dart';
import 'group_list_controller.dart';
import 'home_bar.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      groupListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final groupListValue = ref.watch(groupListStreamProvider);
    final pendingListValue = ref.watch(pendingGroupListStreamProvider);
    return ResponsiveScaffold(
      padding: EdgeInsets.symmetric(horizontal: kSpace),
      appBar: const HomeBar(),
      rail: const HomeRail(),
      //TODO double AsyncValueWidget, a bit ugly, should we create a widget for this cases or am I not dealing with this case properly
      builder: (railPadding) => AsyncValueWidget<List<Group>>(
        value: groupListValue,
        data: (groupList) => AsyncValueWidget<List<Group>>(
            value: pendingListValue,
            data: (pendingList) => ListView(
                  padding: railPadding.add(
                    const EdgeInsets.only(bottom: kFabSpace),
                  ),
                  children: [
                    if (pendingList.isNotEmpty) ...[
                      GroupListTitle(context.loc.invites),
                      //TODO this widget shouldn't have padding applied, think about how we wanna solve this (padding comes from ResponsiveScaffold)
                      HorizontalPendingView(groups: pendingList),
                      if (groupList.isNotEmpty)
                        GroupListTitle(context.loc.groups),
                    ],
                    if (groupList.isEmpty)
                      const EmptyGroupList()
                    else ...[
                      for (final group in groupList) GroupCard(group: group),
                    ],
                  ],
                )),
      ),
      floatingActionButton: groupListValue.valueOrNull?.isNotEmpty == true
          ? const CreateGroupButton.fab()
          : null,
    );
  }
}
