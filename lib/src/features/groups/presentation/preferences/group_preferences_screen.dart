import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/groups/presentation/preferences/group_preferences_controller.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class GroupPreferencesScreen extends ConsumerWidget {
  final String groupId;
  const GroupPreferencesScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupPreferencesControllerProvider);
    final groupValue = ref.watch(groupStreamProvider(groupId));
    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        return ResponsiveScaffold(
          appBar: AppBar(title: Text(context.loc.preferences)),
          rail: Rail(title: context.loc.preferences),
          builder: (topPadding) => ListView(
            padding: EdgeInsets.only(top: topPadding),
            children: [
              ListTile(
                onTap: () => context.pushNamed(
                  AppRoute.groupDetails.name,
                  params: {'groupId': group.id},
                ),
                leading: GroupAvatar(group, dialogOnTap: false),
                title: Text(group.name),
              ),
              const Divider(),
              SelectionSettingTile<GroupPlan>(
                loading: state.isLoading,
                selected: group.plan,
                onChanged: (plan) => ref
                    .read(groupPreferencesControllerProvider.notifier)
                    .changePlan(group, plan),
                options: GroupPlan.values,
                icon: Icons.auto_awesome,
                title: context.loc.plan,
                description: context.loc.planDescription,
              ),
              ListTile(
                onTap: () => context.pushNamed(
                  AppRoute.motivation.name,
                  params: {'groupId': group.id},
                ),
                leading: const Icon(Icons.mark_chat_read),
                title: Text(context.loc.motivationalMessages),
                subtitle: Text(context.loc.motivationalMessagesDescription),
              ),
            ],
          ),
        );
      },
    );
  }
}
