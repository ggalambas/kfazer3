import 'dart:math';

import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';

final kTestMembers = _members();
Map<int, Map<int, MemberRole>> _members() {
  final members = {
    0: {0: MemberRole.owner},
    1: {0: MemberRole.admin},
    2: {0: MemberRole.member},
    3: {0: MemberRole.pending},
    4: {0: MemberRole.pending},
    5: {0: MemberRole.pending},
  };
  for (final groupId in members.keys) {
    members[groupId] = {1: groupId == 0 ? MemberRole.admin : MemberRole.owner};
    for (var userId = 1; userId < 20; userId++) {
      final roleIndex = Random().nextInt(MemberRole.values.length - 1) + 1;
      members[groupId]![userId] = MemberRole.values[roleIndex];
    }
  }
  return members;
}

Map<GroupId, MemberRole> roles(int userId) => {
      for (var groupId in kTestMembers.keys)
        groupId.toString(): kTestMembers[groupId]![userId]!
    };
Map<UserId, MemberRole> members(int groupId) => {
      for (var userId in kTestMembers[groupId]!.keys)
        userId.toString(): kTestMembers[groupId]![userId]!
    };
