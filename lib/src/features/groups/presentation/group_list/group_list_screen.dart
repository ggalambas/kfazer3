import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'group_card.dart';
import 'group_empty_list.dart';
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
    return ResponsiveScaffold(
      padding: EdgeInsets.symmetric(horizontal: kSpace),
      appBar: const HomeBar(),
      rail: const HomeRail(),
      builder: (railPadding) => AsyncValueWidget<List<Group>>(
        value: groupListValue,
        data: (groupList) => groupList.isEmpty
            ? GroupEmptyList(padding: railPadding)
            : ListView(
                padding: railPadding,
                children: [
                  for (final group in groupList) GroupCard(group: group),
                ],
              ),
      ),
      //TODO test if this IF is properly done
      floatingActionButton: groupListValue.asData?.value.isEmpty == true
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.goNamed(AppRoute.workspaceSetup.name),
              icon: const Icon(Icons.add),
              label: Text(context.loc.createNew),
            ),
    );
  }
}
