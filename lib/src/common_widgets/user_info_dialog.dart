import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'avatar/user_avatar.dart';

Future<void> showUserInfoDialog(
  BuildContext context, {
  required AppUser user,
}) =>
    showDialog(
      context: context,
      builder: (_) => UserInfoDialog(user),
    );

class UserInfoDialog extends StatelessWidget {
  final AppUser user;
  const UserInfoDialog(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
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
