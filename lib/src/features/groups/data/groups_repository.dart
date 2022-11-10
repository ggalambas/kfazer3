import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

final groupRepositoryProvider = Provider<GroupsRepository>(
  (ref) {
    throw Error();
    // final repository = FakeGroupRepository(addDelay: addRepositoryDelay);
    // ref.onDispose(() => repository.dispose());
    // return repository;
  },
);

abstract class GroupsRepository {
  // Stream<List<Group>> fetchGroupList(String uid);
  Stream<List<Group>> watchGroupList(String uid);
  // Future<Group?> fetchGroup(GroupId id);
  Stream<Group?> watchGroup(GroupId id);
  Future<void> setGroup(Group group);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(GroupId id);
}

//* Providers

// final groupListStreamProvider = StreamProvider.autoDispose<List<Group>>(
//   (ref) {
//     final groupRepository = ref.watch(groupRepositoryProvider);
//     return groupRepository.watchGroupList();
//   },
// );

// final groupStreamProvider = StreamProvider.autoDispose.family<Group?, GroupId>(
//   (ref, id) {
//     final groupRepository = ref.watch(groupRepositoryProvider);
//     return groupRepository.watchGroup(id);
//   },
// );
