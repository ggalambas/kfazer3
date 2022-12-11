import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/groups/data/fake_groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';

import 'fake_members_repository.dart';
import 'fake_users_repository.dart';

final membersRepositoryProvider = Provider<MembersRepository>(
  (ref) => FakeMembersRepository(
    groups: ref.watch(fakeGroupsProvider),
    users: ref.watch(fakeUsersProvider),
    addDelay: addRepositoryDelay,
  ),
);

abstract class MembersRepository {
  Stream<List<Member>> watchMembers(GroupId groupId);
  //
  Future<void> setMember(Member member);
  Future<void> removeMember(Member member);
  Future<void> transferOwnership(Member owner, Member member);
}

final membersStreamProvider = StreamProvider.family<List<Member>, GroupId>(
  (ref, groupId) {
    final usersRepository = ref.watch(membersRepositoryProvider);
    return usersRepository.watchMembers(groupId);
  },
);
