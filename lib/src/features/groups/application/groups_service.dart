import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/group_storage_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/features/motivation/data/quotes_repository.dart';

final groupsServiceProvider = Provider<GroupsService>((ref) {
  return GroupsService(ref);
});

class GroupsService {
  final Ref ref;
  GroupsService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  GroupsRepository get groupsRepository => ref.read(groupsRepositoryProvider);
  QuotesRepository get quotesRepository => ref.read(quotesRepositoryProvider);
  GroupStorageRepository get accountStorageRepository =>
      ref.read(groupStorageRepositoryProvider);

  Future<String> createGroup(Group group, List<String> quotes) async {
    final user = authRepository.currentUser!;
    final member = Member.fromAppUser(
      user,
      groupId: group.id,
      role: MemberRole.owner,
    );
    final copy = group.setMember(member);
    final groupId = await groupsRepository.createGroup(copy);
    await quotesRepository.setQuotes(groupId, quotes);
    return groupId;
  }

  Future<void> uploadPictureAndSaveGroup(Group group, Uint8List bytes) async {
    final photoUrl =
        await accountStorageRepository.uploadGroupPicture(group.id, bytes);
    final updatedGroup = group.setPhotoUrl(photoUrl);
    await groupsRepository.updateGroup(updatedGroup);
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
    final member = Member.fromAppUser(
      user,
      groupId: group.id,
      role: MemberRole.member,
    );
    final copy = group.setMember(member);
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

final roleFromGroupProvider = Provider.family.autoDispose<MemberRole, Group>(
  (ref, group) {
    final user = ref.watch(currentUserStateProvider);
    return group.members[user.id]!;
  },
);
