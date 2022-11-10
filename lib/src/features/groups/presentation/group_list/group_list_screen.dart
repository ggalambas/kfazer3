import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_list/home_rail.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'group_card.dart';
import 'home_bar.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  List<Widget> groupCards(List<Group> groupList) =>
      [for (final group in groupList) GroupCard(group: group)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupListValue = ref.watch(groupListStreamProvider);
    return ResponsiveScaffold.builder(
      padding: EdgeInsets.all(kSpace),
      appBar: const HomeBar(),
      rail: const HomeRail(),
      body: (isOneColumn) => AsyncValueWidget<List<Group>>(
        value: groupListValue,
        data: (groupList) => groupList.isEmpty
            ? const GroupEmptyList()
            : isOneColumn
                ? ListView(children: groupCards(groupList))
                : SingleChildScrollView(
                    child: Column(
                      children: groupCards(groupList),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.workspaceSetup.name),
        icon: const Icon(Icons.add),
        label: Text(context.loc.createNew),
      ),
    );
  }
}

class GroupEmptyList extends StatelessWidget {
  const GroupEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace * 3),
      child: Column(
        children: [
          const Spacer(),
          Text(
            // context.loc.groupCreateFirst,
            '',
            style: context.textTheme.displaySmall,
          ),
          Space(),
          Text(
            // context.loc.groupCreateFirstDescription,
            '',
            style: context.textTheme.labelLarge,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
