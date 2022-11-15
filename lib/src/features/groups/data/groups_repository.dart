import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'fake_groups_repository.dart';

//TODO course 8.10

final groupsRepositoryProvider = Provider<GroupsRepository>(
  (ref) {
    final repository = FakeGroupsRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class GroupsRepository {
  // Stream<List<Group>> fetchGroupList(String uid);
  Stream<List<Group>> watchGroupList(String userId);
  Stream<List<Group>> watchPendingGroupList(String userId);
  // Future<Group?> fetchGroup(String id);
  Stream<Group?> watchGroup(String id);
  Future<void> setGroup(Group group);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(String id);
}

//* Providers

//? should this return null or throw an error when group not found
final groupStreamProvider = StreamProvider.autoDispose.family<Group?, String>(
  (ref, id) {
    final repository = ref.watch(groupsRepositoryProvider);
    return repository.watchGroup(id);
  },
);
