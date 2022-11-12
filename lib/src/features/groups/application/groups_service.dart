import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/group_storage_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';

final groupsServiceProvider = Provider<GroupsService>((ref) {
  return GroupsService(ref);
});

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
    final updatedGroup = group.updatePhotoUrl(photoUrl);
    groupsRepository.updateGroup(updatedGroup);
  }

  Future<void> removePictureAndSaveGroup(Group group) async {
    await accountStorageRepository.removeGroupPicture(group.id);
    final updatedGroup = group.updatePhotoUrl(null);
    groupsRepository.updateGroup(updatedGroup);
  }

  Future<void> leaveGroup(Group group) async {
    final user = authRepository.currentUser!;
    final copy = group.removeMember(user.id);
    await groupsRepository.updateGroup(copy);
  }
}

//* Providers

final groupListStreamProvider = StreamProvider.autoDispose<List<Group>>(
  (ref) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref.watch(groupsRepositoryProvider).watchGroupList(user.id);
    }
  },
);

final roleProvider =
    Provider.family.autoDispose<MemberRole, Group>((ref, group) {
  final user = ref.watch(currentUserStateProvider);
  return group.memberRole(user.id);
});
