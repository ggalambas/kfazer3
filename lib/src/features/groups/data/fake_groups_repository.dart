import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
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
  Stream<List<Group>> watchGroupList(String userId) async* {
    await delay(addDelay);
    yield* _groups.stream.map(
      (groups) => groups.where((group) {
        return group.memberIds.contains(userId);
      }).toList(),
    );
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
  Future<void> setGroup(Group group) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, add the group
    groups.add(group);
    // Finally, update the notification list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> updateGroup(Group group) async {
    await delay(addDelay);
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((ws) => group.id == ws.id);
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
    groups.removeWhere((ws) => id == ws.id);
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> leaveGroup(GroupId id) => deleteGroup(id);
}
