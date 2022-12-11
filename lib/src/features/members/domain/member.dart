import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/utils/nullable_comparable.dart';

import 'member_role.dart';
import 'user.dart';

/// Class representing a member
class Member extends AppUser with ComparableMixin {
  final GroupId groupId;
  final MemberRole role;

  const Member({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.photoUrl,
    //
    required this.groupId,
    required this.role,
  });

  factory Member.fromAppUser(
    AppUser user, {
    required GroupId groupId,
    required MemberRole role,
  }) =>
      Member(
        id: user.id,
        name: user.name,
        phoneNumber: user.phoneNumber,
        groupId: groupId,
        role: role,
      );

  factory Member.fromUser(User user, GroupId groupId) =>
      Member.fromAppUser(user, groupId: groupId, role: user.roles[groupId]!);

  /// sort users by member role and then by name
  @override
  int? cmpTo(other) =>
      role.index.cmpTo(other.role.index) ?? name.cmpTo(other.name);
}
