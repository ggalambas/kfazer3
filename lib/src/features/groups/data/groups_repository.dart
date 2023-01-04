import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';

import 'fake_groups_repository.dart';

//TODO course 8.10

final groupsRepositoryProvider = Provider<GroupsRepository>(
  (ref) {
    final repository = FakeGroupsRepository(addDelay: addRepositoryDelay);
    ref.onDispose(repository.dispose);
    return repository;
  },
);

abstract class GroupsRepository {
  Stream<List<Group>> watchGroupList(UserId userId);
  Stream<List<Group>> watchPendingGroupList(UserId userId);
  //
  Future<Group?> fetchGroup(GroupId id);
  Stream<Group?> watchGroup(GroupId id);
  //
  Future<GroupId> createGroup(Group group);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(GroupId id);
  //
  Future<void> setMember(Member member);
  Future<void> removeMember(GroupId groupId, UserId userId);
  Future<void> transferOwnership(UserId ownerId, Member member);
}

//* Providers

final groupStreamProvider = StreamProvider.autoDispose.family<Group?, GroupId>(
  (ref, id) {
    final repository = ref.watch(groupsRepositoryProvider);
    return repository.watchGroup(id);
  },
);
