import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'groups_repository.dart';

class FakeGroupsRepository implements GroupsRepository {
  // An InMemoryStore containing all the groups.
  // final _groups = InMemoryStore<List<Group>>([]);
  final _groups = InMemoryStore<List<Group>>(kTestGroups);
  void dispose() => _groups.close();

  final bool addDelay;
  FakeGroupsRepository({this.addDelay = true});

  @override
  Stream<List<Group>> watchAllGroupsList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        return group.members.containsKey(userId);
      }).toList(),
    );
  }

  @override
  Stream<List<Group>> watchGroupList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        final role = group.members[userId];
        return role != null && role != MemberRole.pending;
      }).toList(),
    );
  }

  @override
  Stream<List<Group>> watchPendingGroupList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        final role = group.members[userId];
        return role != null && role == MemberRole.pending;
      }).toList(),
    );
  }

  @override
  Future<Group?> fetchGroup(String id) async {
    await delay(addDelay);
    return _groups.value.firstWhereOrNull((group) => group.id == id);
  }

  @override
  Stream<Group?> watchGroup(String id) async* {
    yield* _groups.stream.map(
      (groups) => groups.firstWhereOrNull(
        (group) => group.id == id,
      ),
    );
  }

  @override
  Future<String> createGroup(Group group) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, add the group
    final id = groups.length.toString();
    groups.add(group.setId(id));
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
  Future<void> deleteGroup(String id) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, delete the group
    groups.removeWhere((g) => id == g.id);
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }
}
