import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/common_widgets/circular_progress_icon.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/presentation/members/member_tile_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';
import 'package:smart_space/smart_space.dart';

import 'member_menu_button.dart';
import 'member_menu_option.dart';

/// Shows a member tile
class MemberTile extends ConsumerWidget {
  final AppUser targetUser;
  final Member target;
  final Member editor;

  const MemberTile({
    super.key,
    required this.targetUser,
    required this.target,
    required this.editor,
  });

  AutoDisposeStateNotifierProvider<MemberTileController, AsyncValue>
      get controllerProvider => memberTileControllerProvider(targetUser.id);

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
        return ref.read(controllerProvider.notifier).transferOwnership(target);
      case MemberMenuOption.makeAdmin:
        return ref.read(controllerProvider.notifier).turnAdmin(target);
      case MemberMenuOption.removeAdmin:
        return ref.read(controllerProvider.notifier).revokeAdmin(target);
      case MemberMenuOption.removeMember:
      case MemberMenuOption.removeInvite:
        final confirmed = await showAlertDialog(
          context: context,
          title: context.loc.areYouSure,
          cancelActionText: context.loc.cancel,
          defaultActionText: context.loc.remove,
        );
        if (confirmed != true) break;
        return ref.read(controllerProvider.notifier).removeMember(target);
    }
  }

  TextStyle? roleStyle() {
    switch (target.role) {
      case MemberRole.pending:
        return const TextStyle(fontStyle: FontStyle.italic);
      default:
        return null;
    }
  }

  bool get editable =>
      (editor.role.isAdmin || editor.role.isOwner) && !target.role.isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      controllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(controllerProvider);
    return ListTile(
      leading: UserAvatar(targetUser, dialogOnTap: false),
      title: Text(targetUser.name),
      subtitle: Text(targetUser.phoneNumber.toString()),
      // removing right padding when trailing is a button
      contentPadding: editable && !state.isLoading
          ? EdgeInsets.only(left: kSpace * 2)
          : null,
      trailing: state.isLoading
          ? const CircularProgressIcon()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!target.role.isMember)
                  Text(target.role.locName(context), style: roleStyle()),
                if (editable)
                  MemberMenuButton(
                    options: MemberMenuOption.allowedValues(editor, target),
                    onOptionSelected: (option) =>
                        handleOption(context, ref, option),
                  )
              ],
            ),
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
