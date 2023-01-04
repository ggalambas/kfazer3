import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/nullable_comparable.dart';

import 'member_tile.dart';

class MembersScreen extends ConsumerWidget {
  final String groupId;
  const MembersScreen({super.key, required this.groupId});

  List<AppUser> sortedUsers(Group group, List<AppUser> users) => users
    ..nSort((a, b) {
      final aRole = group.member(a.id).role;
      final bRole = group.member(b.id).role;
      return aRole.index.nCompareTo(bRole.index) ?? a.name.nCompareTo(b.name);
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);
    final groupValue = ref.watch(groupStreamProvider(groupId));
    return AsyncValueWidget<Group?>(
        value: groupValue,
        data: (group) {
          if (group == null) return const NotFoundGroup();
          final usersValue = ref.watch(userListStreamProvider(group));
          return ResponsiveScaffold(
            appBar: AppBar(title: Text(context.loc.members)),
            rail: Rail(title: context.loc.members),
            builder: (topPadding) {
              return AsyncValueWidget<List<AppUser>>(
                value: usersValue,
                loading: ListView.builder(
                  padding: EdgeInsets.only(top: topPadding),
                  itemCount: group.userIds.length,
                  itemBuilder: (context, _) => const LoadingMemberTile(),
                ),
                data: (users) {
                  users = sortedUsers(group, users);
                  return ListView.builder(
                    padding: EdgeInsets.only(top: topPadding),
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final user = users[i];
                      return MemberTile(
                        targetUser: user,
                        target: group.member(user.id),
                        editor: group.member(currentUser.id),
                      );
                    },
                  );
                },
              );
            },
          );
        });
  }
}
