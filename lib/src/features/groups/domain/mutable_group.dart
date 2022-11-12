import 'package:kfazer3/src/features/groups/domain/group_plan.dart';

import 'group.dart';

// TODO comments
// TODO tests

/// Helper extension used to update a group
extension MutableGroup on Group {
  Group updateTitle(String title) => copyWith(title: title);

  Group updateDescription(String description) =>
      copyWith(description: description);

  Group updatePhotoUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, nullablePhotoUrl: true);

  Group updatePlan(GroupPlan plan) => copyWith(plan: plan);

  Group updateMotivationalMessages(List<String> motivationalMessages) =>
      copyWith(motivationalMessages: motivationalMessages);

  Group removeMember(String memberId) =>
      copyWith(memberRoles: memberRoles..remove(memberId));

  Group copyWith({
    String? title,
    String? description,
    String? photoUrl,
    bool nullablePhotoUrl = false,
    List<String>? motivationalMessages,
    GroupPlan? plan,
    Map<String, MemberRole>? memberRoles,
  }) =>
      Group(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        photoUrl: nullablePhotoUrl ? photoUrl : (photoUrl ?? this.photoUrl),
        motivationalMessages: motivationalMessages ?? this.motivationalMessages,
        plan: plan ?? this.plan,
        memberRoles: memberRoles ?? this.memberRoles,
      );
}
