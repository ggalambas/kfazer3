import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/rail.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class GroupPreferencesScreen extends ConsumerWidget {
  final String groupId;
  const GroupPreferencesScreen({super.key, required this.groupId});

  void changePlan(Reader read, Group group, GroupPlan plan) {
    final newGroup = group.updatePlan(plan);
    read(groupsRepositoryProvider).updateGroup(newGroup);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(groupStreamProvider(groupId));
    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        final preferences = preferenceList(context, ref, group);
        return ResponsiveScaffold.builder(
          appBar: AppBar(title: Text(context.loc.preferences)),
          rail: Rail(title: context.loc.preferences),
          body: (isOneColumn) => isOneColumn
              ? ListView(children: preferences)
              : SingleChildScrollView(child: Column(children: preferences)),
        );
      },
    );
  }

  List<Widget> preferenceList(
          BuildContext context, WidgetRef ref, Group group) =>
      [
        ListTile(
          onTap: () => context.goNamed(
            AppRoute.groupDetails.name,
            params: {'groupId': group.id},
          ),
          leading: GroupAvatar(group),
          title: Text(group.title),
        ),
        const Divider(),
        SelectionSettingTile<GroupPlan>(
          selected: group.plan,
          onChanged: (plan) => changePlan(ref.read, group, plan),
          options: GroupPlan.values,
          icon: Icons.auto_awesome,
          title: context.loc.plan,
          description: context.loc.planDescription,
        ),
        ListTile(
          onTap: () => context.goNamed(
            AppRoute.motivation.name,
            params: {'groupId': group.id},
          ),
          leading: const Icon(Icons.mark_chat_read),
          title: Text(context.loc.motivationalMessages),
          subtitle: Text(context.loc.motivationalMessagesDescription),
        ),
      ];
}
