import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import '../user_info_dialog.dart';
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
          ? () => showUserInfoDialog(context, user: user!)
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
