import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_member.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'groups_repository.dart';

class FakeGroupsRepository implements GroupsRepository {
  /// An InMemoryStore containing all the groups.
  final _groups = InMemoryStore<List<Group>>(kTestGroups);
  final bool addDelay;

  FakeGroupsRepository({this.addDelay = true});
  void dispose() => _groups.close();

  @override
  Stream<List<Group>> watchGroupList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        final role = group.members[userId]?.role;
        return role != null && role != MemberRole.pending;
      }).toList(),
    );
  }

  @override
  Stream<List<Group>> watchPendingGroupList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        final role = group.members[userId]?.role;
        return role != null && role == MemberRole.pending;
      }).toList(),
    );
  }

  @override
  Future<Group?> fetchGroup(GroupId id) async {
    await delay(addDelay);
    return _groups.value.firstWhereOrNull((group) => group.id == id);
  }

  @override
  Stream<Group?> watchGroup(GroupId id) async* {
    yield* _groups.stream.map(
      (groups) => groups.firstWhereOrNull(
        (group) => group.id == id,
      ),
    );
  }

  @override
  Future<GroupId> createGroup(Group group) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, add the group
    final id = groups.length.toString();
    groups.add(group.copyWith(id: id));
    // Finally, update the notification list data (will emit a new value)
    _groups.value = groups;
    return id;
  }

  @override
  Future<void> updateGroup(Group group) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => group.id == g.id);
    groups[i] = group;
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> deleteGroup(GroupId id) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, delete the group
    groups.removeWhere((g) => id == g.id);
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> removeMember(GroupId groupId, UserId userId) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => groupId == g.id);
    var group = groups[i].removeMemberById(userId);
    groups[i] = group;
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> setMember(Member member) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => member.groupId == g.id);
    var group = groups[i].setMember(member);
    groups[i] = group;
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> transferOwnership(UserId ownerId, Member member) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => member.groupId == g.id);
    var group = groups[i];
    final oldOwner = group.member(ownerId).setRole(MemberRole.admin);
    final newOwner = member.setRole(MemberRole.owner);
    groups[i] = group.setMember(oldOwner).setMember(newOwner);
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }
}
