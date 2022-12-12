import 'dart:math';

import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';

final kTestMembers = _members();

const kTestGroupsLength = 6;
const kTestUsersLength = 20;

List<Map<String, int>> _members() {
  final members = <Map<String, int>>[];
  for (var groupId = 0; groupId < kTestGroupsLength; groupId++) {
    for (var userId = 0; userId < kTestUsersLength; userId++) {
      members.add({
        'group': groupId,
        'user': userId,
        'role': role(groupId, userId),
      });
    }
  }
  return members;
}

int role(int groupId, int userId) {
  if (userId == 0) {
    if (groupId == 0) return MemberRole.owner.index;
    if (groupId == 1) return MemberRole.admin.index;
    if (groupId == 2) return MemberRole.member.index;
    return MemberRole.pending.index;
  }
  if (userId == 1) {
    if (groupId == 0) return MemberRole.admin.index;
    return MemberRole.owner.index;
  }
  return Random().nextInt(MemberRole.values.length - 1) + 1;
}

Map<GroupId, MemberRole> roles(int userId) {
  final members = kTestMembers.where((member) => member['user'] == userId);
  return {
    for (var member in members)
      member['group']!.toString(): MemberRole.values[member['role']!]
  };
}

Map<UserId, MemberRole> members(int groupId) {
  final members = kTestMembers.where((member) => member['group'] == groupId);
  return {
    for (var member in members)
      member['user']!.toString(): MemberRole.values[member['role']!]
  };
}
