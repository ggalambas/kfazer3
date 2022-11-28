import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';

import 'member_tile.dart';

class MembersScreen extends ConsumerWidget {
  final String groupId;
  const MembersScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(groupStreamProvider(groupId));
    final user = ref.watch(currentUserStateProvider);
    //TODO loading is ugly
    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        return ResponsiveScaffold(
          appBar: AppBar(title: Text(context.loc.preferences)),
          rail: Rail(title: context.loc.preferences),
          builder: (railPadding) {
            return ListView(
              padding: railPadding,
              children: [
                //TODO sort?
                for (final member in group.toMemberList())
                  MemberTile(
                    member,
                    editable: true, //TODO editable if user is admin
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
