import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/members/data/members_repository.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

import 'member_tile.dart';

class MembersScreen extends ConsumerWidget {
  final String groupId;
  const MembersScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersValue = ref.watch(membersStreamProvider(groupId));
    final user = ref.watch(currentUserStateProvider);
    return ResponsiveScaffold(
      appBar: AppBar(title: Text(context.loc.members)),
      rail: Rail(title: context.loc.members),
      builder: (topPadding) {
        return AsyncValueWidget<List<Member>>(
          value: membersValue,
          loading: ListView.builder(
            padding: EdgeInsets.only(top: topPadding),
            itemBuilder: (contetx, _) => const LoadingMemberTile(),
          ),
          data: (members) {
            if (members.isEmpty) return const NotFoundGroup();
            final userAsMember =
                members.firstWhere((member) => member.id == user.id);
            return ListView(
              padding: EdgeInsets.only(top: topPadding),
              children: [
                for (final member in members..sort())
                  MemberTile(member, editor: userAsMember),
              ],
            );
          },
        );
      },
    );
  }
}
