import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/common_widgets/circular_progress_icon.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/presentation/members/member_tile_controller.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';
import 'package:smart_space/smart_space.dart';

import 'member_menu_button.dart';

/// Shows a member tile (or loading/error UI if needed)
/// or a shrinked space if it doesn't exist
class MemberTile extends ConsumerWidget {
  final Member member;
  final bool editable;
  const MemberTile(this.member, {super.key, this.editable = false});

  MemberRole get role => member.role;
  bool get showMenuButton => editable && !role.isOwner;

  AutoDisposeStateNotifierProvider<MemberTileController, AsyncValue>
      get memberProvider => memberTileControllerProvider(member.id);

  Future<void> handleOption(
    BuildContext context,
    WidgetRef ref,
    MemberMenuOption option,
  ) async {
    switch (option) {
      case MemberMenuOption.transferOwnership:
        final confirmed = await showAlertDialog(
          context: context,
          title: context.loc.areYouSure,
          cancelActionText: context.loc.cancel,
          defaultActionText: context.loc.transfer,
        );
        if (confirmed != true) break;
        return ref.read(memberProvider.notifier).transferOwnership(member);
      case MemberMenuOption.makeAdmin:
        return ref.read(memberProvider.notifier).turnAdmin(member);
      case MemberMenuOption.removeAdmin:
        return ref.read(memberProvider.notifier).revokeAdmin(member);
      case MemberMenuOption.removeMember:
      case MemberMenuOption.removeInvite:
        final confirmed = await showAlertDialog(
          context: context,
          title: context.loc.areYouSure,
          cancelActionText: context.loc.cancel,
          defaultActionText: context.loc.remove,
        );
        if (confirmed != true) break;
        return ref.read(memberProvider.notifier).removeMember(member);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      memberProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(memberProvider);
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
          // remove right padding when trailing is a button
          contentPadding: showMenuButton && !state.isLoading
              ? EdgeInsets.only(left: kSpace * 2)
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: state.isLoading
                ? [const CircularProgressIcon()]
                : [
                    if (!role.isMember)
                      Text(
                        role.locName(context),
                        style: role.isPending
                            ? const TextStyle(fontStyle: FontStyle.italic)
                            : null,
                      ),
                    if (showMenuButton)
                      MemberMenuButton(
                        role: role,
                        onOptionSelected: (option) =>
                            handleOption(context, ref, option),
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
    final textHeight = context.textTheme.bodyMedium!.fontSize!;
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colorScheme.surfaceVariant,
        ),
      ),
      title: Container(
        height: textHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(textHeight / 2),
          color: context.colorScheme.surfaceVariant,
        ),
      ),
      subtitle: LayoutBuilder(builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: textHeight,
            width: constraints.maxWidth / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(textHeight / 2),
              color: context.colorScheme.surfaceVariant,
            ),
          ),
        );
      }),
      trailing: const SizedBox.shrink(),
    ).loader(context);
  }
}
