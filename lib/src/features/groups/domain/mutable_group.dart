import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';

import 'group.dart';
import 'member.dart';

/// Helper extension used to update a group
extension MutableGroup on Group {
  Group setName(String name) => copyWith(name: name);

  Group setDescription(String description) =>
      copyWith(description: description);

  Group setPhotoUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, nullablePhotoUrl: true);

  Group setPlan(GroupPlan plan) => copyWith(plan: plan);

  /// If a member with the given userId is found, remove it
  Group removeMemberById(UserId memberId) {
    final copy = Map<UserId, Member>.from(members);
    copy.remove(memberId);
    return copyWith(members: copy);
  }

  /// Add a member to the group by *overriding* the role if it already exists
  Group setMember(Member member) {
    final copy = Map<UserId, Member>.from(members);
    copy[member.userId] = member;
    return copyWith(members: copy);
  }

  /// Add a list of members to the group by *overriding* the roles of members that already exists
  Group setMembers(List<Member> membersToSet) {
    final copy = Map<UserId, Member>.from(members);
    for (final member in membersToSet) {
      copy[member.userId] = member;
    }
    return copyWith(members: copy);
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    bool nullablePhotoUrl = false,
    GroupPlan? plan,
    Map<UserId, Member>? members,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        photoUrl: nullablePhotoUrl ? photoUrl : (photoUrl ?? this.photoUrl),
        plan: plan ?? this.plan,
        members: members ?? this.members,
      );
}
