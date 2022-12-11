import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';

/// Clas representing an user
class User extends AppUser {
  final Map<GroupId, MemberRole> roles;

  const User({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.photoUrl,
    //
    required this.roles,
  });
}

//?
// class Member extends AppUser {
  // final GroupId groupId;
  // final MemberRole role;
// }
