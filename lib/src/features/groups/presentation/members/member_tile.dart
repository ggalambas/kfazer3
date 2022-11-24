// import 'package:flutter/material.dart';
// import 'package:kfazer3/src/common_widgets/user_avatar.dart';
// import 'package:kfazer3/src/features/auth/domain/app_user.dart';
// import 'package:kfazer3/src/features/groups/domain/group.dart';

// class MemberTile extends StatelessWidget {
//   final AppUser user;
//   final MemberRole role;
//   const MemberTile(this.user, {super.key, required this.role});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: UserAvatar(user, dialogOnTap: false),
//       title: Text(user.name),
//       subtitle: Text(user.phoneNumber.toString()),
//       //TODO admin dropdown
//       trailing: Text(role.name),
//     );
//   }
// }

// class MemberTileOr