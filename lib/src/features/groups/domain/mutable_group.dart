import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';

import 'group.dart';
import 'member_role.dart';

/// Helper extension used to update a group
extension MutableGroup on Group {
  Group setId(String id) => copyWith(id: id);
  Group setName(String name) => copyWith(name: name);

  Group setDescription(String description) =>
      copyWith(description: description);

  Group setPhotoUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, nullablePhotoUrl: true);

  Group setPlan(GroupPlan plan) => copyWith(plan: plan);

  Group setMotivationalMessages(List<String> motivationalMessages) =>
      copyWith(motivationalMessages: motivationalMessages);

  /// If a member with the given userId is found, remove it
  Group removeMemberById(UserId memberId) {
    final copy = Map<UserId, MemberRole>.from(members);
    copy.remove(memberId);
    return copyWith(members: copy);
  }

  /// Add a member to the group by *overriding* the role if it already exists
  Group setMember(Member member) {
    final copy = Map<UserId, MemberRole>.from(members);
    copy[member.id] = member.role;
    return copyWith(members: copy);
  }

  /// Add a list of members to the group by *overriding* the roles of members that already exists
  Group setMembers(List<Member> membersToSet) {
    final copy = Map<UserId, MemberRole>.from(members);
    for (final member in membersToSet) {
      copy[member.id] = member.role;
    }
    return copyWith(members: copy);
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    bool nullablePhotoUrl = false,
    List<String>? motivationalMessages,
    GroupPlan? plan,
    Map<UserId, MemberRole>? members,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        photoUrl: nullablePhotoUrl ? photoUrl : (photoUrl ?? this.photoUrl),
        motivationalMessages: motivationalMessages ?? this.motivationalMessages,
        plan: plan ?? this.plan,
        members: members ?? this.members,
      );
}
