import 'dart:math';

import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';

import 'test_users.dart';

const kTestGroupsLength = 6;

/// Test groups to be used until a data source is implemented
final kTestGroups = List.generate(
  kTestGroupsLength,
  (i) => Group(
    id: '$i',
    name: 'Group $i',
    description: 'A group made by him for the company.' * (i % 3),
    plan: GroupPlan.family,
    members: _members(i),
  ),
);

Map<UserId, Member> _members(int groupId) {
  return {
    for (var userId = 0; userId < kTestUsersLength; userId++)
      userId.toString(): Member(
        userId: userId.toString(),
        groupId: groupId.toString(),
        inviteDate: DateTime.now(),
        joiningDate: DateTime.now(),
        role: _role(groupId, userId),
      ),
  };
}

MemberRole _role(int groupId, int userId) {
  if (userId == 0) {
    if (groupId == 0) return MemberRole.owner;
    if (groupId == 1) return MemberRole.admin;
    if (groupId == 2) return MemberRole.member;
    return MemberRole.pending;
  }
  if (userId == 1) {
    if (groupId == 0) return MemberRole.admin;
    return MemberRole.owner;
  }
  final index = Random().nextInt(MemberRole.values.length - 1) + 1;
  return MemberRole.values[index];
}
