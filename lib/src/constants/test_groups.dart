import 'package:kfazer3/src/constants/test_members.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';

/// Test groups to be used until a data source is implemented
List<Group> get kTestGroups => [..._kTestGroups];

final _kTestGroups = List.generate(
  kTestGroupsLength,
  (i) => Group(
    id: '$i',
    name: 'Group $i',
    description: 'A group made by him for the company.' * (i % 3),
    plan: GroupPlan.family,
    members: members(i),
  ),
);
