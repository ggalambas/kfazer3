import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/user_avatar.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';

import 'role_menu_button.dart';

/// Shows a member tile (or loading/error UI if needed)
/// or a shrinked space if it doesn't exist
class MemberTile extends ConsumerWidget {
  final Member member;
  final bool editable;
  const MemberTile(this.member, {super.key, this.editable = false});

  MemberRole get role => member.role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(userStreamProvider(member.id));
    return AsyncValueWidget<AppUser?>(
      value: userValue,
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return ListTile(
          leading: UserAvatar(user, dialogOnTap: false),
          title: Text(user.name),
          subtitle: Text(user.phoneNumber.toString()),
          contentPadding:
              role.isMember ? const EdgeInsets.only(left: 16) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!role.isMember)
                Text(
                  role.locName(context),
                  style: role.isPending
                      ? const TextStyle(fontStyle: FontStyle.italic)
                      : null,
                ),
              //TODO change member role
              if (editable && !role.isPending && !role.isOwner)
                RoleMenuButton(
                  role: role,
                  onTurnOwner: () =>
                      showNotImplementedAlertDialog(context: context),
                  onTurnAdmin: () =>
                      showNotImplementedAlertDialog(context: context),
                  onRevokeAdmin: () =>
                      showNotImplementedAlertDialog(context: context),
                )
            ],
          ),
        );
      },
    );
  }
}