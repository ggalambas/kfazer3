import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

import 'member_tile.dart';

class MembersScreen extends ConsumerWidget {
  final String groupId;
  const MembersScreen({super.key, required this.groupId});

  // sort users by member role and then by name
  List<AppUser> sortUsers(List<AppUser> users, Group group) => users
    ..sort((a, b) {
      final aRole = group.members[a.id]!;
      final bRole = group.members[b.id]!;
      final byRole = aRole.index.compareTo(bRole.index);
      if (byRole != 0) return byRole;
      return a.name.compareTo(b.name);
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(groupStreamProvider(groupId));
    final usersValue = ref.watch(groupUsersStreamProvider(groupId));
    return AsyncValueWidget<Group?>(
        value: groupValue,
        data: (group) {
          if (group == null) return const NotFoundGroup();
          final role = ref.watch(roleProvider(group));
          return ResponsiveScaffold(
            appBar: AppBar(title: Text(context.loc.members)),
            rail: Rail(title: context.loc.members),
            builder: (topPadding) {
              //TODO create widget for loading and data
              return AsyncValueWidget<List<AppUser>>(
                value: usersValue,
                loading: ListView(
                  padding: EdgeInsets.only(top: topPadding),
                  children: List.filled(
                    group.members.length,
                    const LoadingMemberTile(),
                  ),
                ),
                data: (users) {
                  users = sortUsers(users, group);
                  return ListView(
                    padding: EdgeInsets.only(top: topPadding),
                    children: [
                      for (final user in users)
                        MemberTile(
                          user,
                          group
                              .toMemberList()
                              .firstWhere((member) => member.id == user.id),
                          editable: role.isOwner || role.isAdmin,
                        ),
                    ],
                  );
                },
              );
            },
          );
        });
  }
}
