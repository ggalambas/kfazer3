import 'package:kfazer3/src/features/groups/data/fake_groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/features/members/domain/mutable_member.dart';
import 'package:kfazer3/src/features/members/domain/mutable_user.dart';
import 'package:kfazer3/src/utils/delay.dart';

import 'fake_users_repository.dart';
import 'members_repository.dart';

class FakeMembersRepository implements MembersRepository {
  /// An InMemoryStore containing all the groups.
  final InMemoryGroups _groups;

  /// An InMemoryStore containing all the users.
  final InMemoryUsers _users;
  final bool addDelay;

  FakeMembersRepository({
    required InMemoryGroups groups,
    required InMemoryUsers users,
    this.addDelay = true,
  })  : _users = users,
        _groups = groups;

  @override
  Stream<List<Member>> watchMembers(GroupId groupId) async* {
    await delay(addDelay);
    yield* _users.stream.map(
      (users) => users
          .where((user) => user.roles.containsKey(groupId))
          .map((user) => Member.fromUser(user, groupId))
          .toList(),
    );
  }

  @override
  Future<void> removeMember(Member member) async {
    await delay(addDelay);
    removeGroupFromUser(member);
    removeMemberFromGroup(member);
  }

  void removeGroupFromUser(Member member) async {
    // First, get the users list
    final users = _users.value;
    // Then, change the user
    final i = users.indexWhere((u) => member.id == u.id);
    final user = users[i].removeRoleByGroupId(member.groupId);
    users[i] = user;
    // Finally, update the user list data (will emit a new value)
    _users.value = users;
  }

  void removeMemberFromGroup(Member member) async {
    //* update group
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => member.groupId == g.id);
    final group = groups[i].removeMemberById(member.id);
    groups[i] = group;
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }

  @override
  Future<void> setMember(Member member) async {
    await delay(addDelay);
    setUserRole(member);
    setGroupMembers([member]);
  }

  @override
  Future<void> transferOwnership(Member owner, Member member) async {
    final oldOwner = owner.setRole(MemberRole.admin);
    final newOwner = member.setRole(MemberRole.admin);
    setUserRole(oldOwner);
    setUserRole(newOwner);
    setGroupMembers([oldOwner, newOwner]);
  }

  void setUserRole(Member member) async {
    // First, get the users list
    final users = _users.value;
    // Then, change the user
    final i = users.indexWhere((u) => member.id == u.id);
    final user = users[i].setRole(member.groupId, member.role);
    users[i] = user;
    // Finally, update the user list data (will emit a new value)
    _users.value = users;
  }

  void setGroupMembers(List<Member> members) async {
    //* update group
    // First, get the group list
    final groups = _groups.value;
    // Then, change the group
    final i = groups.indexWhere((g) => members.first.groupId == g.id);
    var group = groups[i];
    for (final member in members) {
      group = group.setMember(member);
    }
    groups[i] = group;
    // Finally, update the group list data (will emit a new value)
    _groups.value = groups;
  }
}
