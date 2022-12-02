import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/presentation/members/member_tile_controller.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';

import 'role_menu_button.dart';

/// Shows a member tile (or loading/error UI if needed)
/// or a shrinked space if it doesn't exist
class MemberTile extends ConsumerWidget {
  final Member member;
  final bool editable;
  const MemberTile(this.member, {super.key, this.editable = false});

  MemberRole get role => member.role;
  bool get showMenuButton => editable && !role.isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      memberTileControllerProvider(member.id),
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(memberTileControllerProvider(member.id));
    final userValue = ref.watch(userStreamProvider(member.id));
    return AsyncValueWidget<AppUser?>(
      value: userValue,
      loading: const LoadingMemberTile(),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return ListTile(
          leading: UserAvatar(user, dialogOnTap: false),
          title: Text(user.name),
          subtitle: Text(user.phoneNumber.toString()),
          contentPadding: showMenuButton && !state.isLoading
              ? const EdgeInsets.only(left: 16)
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: state.isLoading
                ? [
                    const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ]
                : [
                    if (!role.isMember)
                      Text(
                        role.locName(context),
                        style: role.isPending
                            ? const TextStyle(fontStyle: FontStyle.italic)
                            : null,
                      ),
                    //TODO transfer ownership popup
                    //TODO transfer ownership, downgrade owner to admin
                    //TODO remove member
                    if (showMenuButton)
                      RoleMenuButton(
                        role: role,
                        onRoleChanged: (role) => ref
                            .read(memberTileControllerProvider(member.id)
                                .notifier)
                            .updateRole(member, role),
                      )
                  ],
          ),
        );
      },
    );
  }
}

/// The loading widget for [MemberTile].
class LoadingMemberTile extends StatelessWidget {
  const LoadingMemberTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium!;
    final textHeight = textStyle.fontSize! * textStyle.height!;
    return ListTile(
      leading: const Card(
        margin: EdgeInsets.zero,
        shape: CircleBorder(),
        child: SizedBox.square(dimension: 32),
      ),
      title: Card(child: SizedBox(height: textHeight)),
      subtitle: Card(child: SizedBox(height: textHeight)),
    ).loader(context);
  }
}
