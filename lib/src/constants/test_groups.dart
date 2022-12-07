import 'dart:math';

import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';

/// Test groups to be used until a data source is implemented
List<Group> get kTestGroups => [..._kTestGroups];
final _kTestGroups = List.generate(
  6,
  (i) => Group(
    id: '$i',
    name: 'Group $i',
    description: 'A group made by him for the company.' * (i % 3),
    plan: GroupPlan.family,
    members: Map.fromIterable(
      // user 0 + random users
      kTestUsers.where((user) {
        if (user.id == '0') return true;
        return Random().nextBool();
      }).map((user) => user.id),
      value: (userId) {
        if (userId == '0') {
          if (i == 0) return MemberRole.owner;
          if (i == 1) return MemberRole.admin;
          if (i == 2) return MemberRole.member;
          if (i >= 3) return MemberRole.pending;
        }
        return [MemberRole.member, MemberRole.pending][Random().nextInt(2)];
      },
    ),
  ),
);
