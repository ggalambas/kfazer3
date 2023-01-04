import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/group_storage_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
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
    final member = Member(
      userId: user.id,
      groupId: group.id,
      role: MemberRole.owner,
      inviteDate: DateTime.now(), //TODO dates
      joiningDate: DateTime.now(),
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

  //

  Future<void> leaveGroup(GroupId groupId) async {
    final user = authRepository.currentUser!;
    await groupsRepository.removeMember(groupId, user.id);
  }

  Future<void> joinGroup(Group group) async {
    final user = authRepository.currentUser!;
    final member = Member(
      userId: user.id,
      groupId: group.id,
      role: MemberRole.member,
      inviteDate: DateTime.now(), //TODO dates
      joiningDate: DateTime.now(),
    );
    await groupsRepository.setMember(member);
  }

  Future<void> transferOwnership(Member member) async {
    final user = authRepository.currentUser!;
    await groupsRepository.transferOwnership(user.id, member);
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
    return group.member(user.id).role;
  },
);
