import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'avatar.dart';

/// Circle avatar with the user photo and initials.
class UserAvatar extends StatelessWidget {
  final AppUser? user;
  final double radius;
  final bool dialogOnTap;

  const UserAvatar(
    this.user, {
    super.key,
    this.radius = 16,
    this.dialogOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dialogOnTap && user != null
          ? () => showDialog(
                context: context,
                builder: (_) => UserInfoDialog(user!),
              )
          : null,
      child: Avatar(
        text: user?.name,
        radius: radius,
        foregroundImage:
            user?.photoUrl == null ? null : NetworkImage(user!.photoUrl!),
      ),
    );
  }
}

class UserInfoDialog extends ConsumerWidget {
  final AppUser user;
  const UserInfoDialog(this.user, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Space(),
          UserAvatar(
            user,
            radius: kSpace * 5,
            dialogOnTap: false,
          ),
          Space(2),
          Text(
            user.name,
            style: context.textTheme.titleLarge,
          ),
          Text(
            user.phoneNumber.full,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(context.loc.ok),
        ),
      ],
    );
  }
}
