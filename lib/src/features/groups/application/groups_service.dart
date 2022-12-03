import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/group_storage_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_member.dart';

final groupsServiceProvider = Provider<GroupsService>((ref) {
  return GroupsService(ref);
});

// TODO check all services and repositorys for potantial concurrent wirte failures
class GroupsService {
  final Ref ref;
  GroupsService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  GroupsRepository get groupsRepository => ref.read(groupsRepositoryProvider);
  GroupStorageRepository get accountStorageRepository =>
      ref.read(groupStorageRepositoryProvider);

  Future<void> uploadPictureAndSaveGroup(Group group, Uint8List bytes) async {
    final photoUrl =
        await accountStorageRepository.uploadGroupPicture(group.id, bytes);
    final updatedGroup = group.setPhotoUrl(photoUrl);
    groupsRepository.updateGroup(updatedGroup);
  }

  Future<void> removePictureAndSaveGroup(Group group) async {
    await accountStorageRepository.removeGroupPicture(group.id);
    final updatedGroup = group.setPhotoUrl(null);
    groupsRepository.updateGroup(updatedGroup);
  }

  Future<void> leaveGroup(Group group) async {
    final user = authRepository.currentUser!;
    final copy = group.removeMemberById(user.id);
    await groupsRepository.updateGroup(copy);
  }

  Future<void> joinGroup(Group group) async {
    final user = authRepository.currentUser!;
    final member = Member(id: user.id, groupId: group.id);
    final copy = group.setMember(member);
    await groupsRepository.updateGroup(copy);
  }

  Future<void> transferOwnership(Member member) async {
    final group = await groupsRepository.fetchGroup(member.groupId);
    final currentUser = authRepository.currentUser!;
    // check if current user is owner
    assert(group!.members[currentUser.id]!.isOwner);
    // change owner to admin
    final currentOwner = Member(
      id: currentUser.id,
      groupId: group!.id,
      role: MemberRole.admin,
    );
    // change member to owner
    final newOwner = member.setRole(MemberRole.owner);
    // update group
    final copy = group.setMember(currentOwner).setMember(newOwner);
    await groupsRepository.updateGroup(copy);
  }
}

//* Providers

final allGroupsListStreamProvider = StreamProvider.autoDispose<List<Group>>(
  (ref) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref.watch(groupsRepositoryProvider).watchAllGroupsList(user.id);
    }
  },
);

final groupListStreamProvider = StreamProvider.autoDispose<List<Group>>(
  (ref) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref.watch(groupsRepositoryProvider).watchGroupList(user.id);
    }
  },
);

final pendingGroupListStreamProvider = StreamProvider.autoDispose<List<Group>>(
  (ref) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref.watch(groupsRepositoryProvider).watchPendingGroupList(user.id);
    }
  },
);

final roleProvider =
    Provider.family.autoDispose<MemberRole, Group>((ref, group) {
  final user = ref.watch(currentUserStateProvider);
  return group.members[user.id]!;
});
