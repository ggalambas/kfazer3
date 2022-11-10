import 'package:kfazer3/src/features/groups/domain/group_plan.dart';

import 'group.dart';

// TODO comments
// TODO tests
// TODO add/remove member method

/// Helper extension used to change workspace details
extension MutableGroup on Group {
  Group updateTitle(String title) => copyWith(title: title);

  Group updateDescription(String description) =>
      copyWith(description: description);

  Group updatePlan(GroupPlan plan) => copyWith(plan: plan);

  Group updateMotivationalMessages(List<String> motivationalMessages) =>
      copyWith(motivationalMessages: motivationalMessages);

  Group copyWith({
    String? title,
    String? description,
    String? photoUrl,
    List<String>? motivationalMessages,
    GroupPlan? plan,
    List<String>? memberIds,
  }) =>
      Group(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        photoUrl: photoUrl ?? this.photoUrl,
        motivationalMessages: motivationalMessages ?? this.motivationalMessages,
        plan: plan ?? this.plan,
        memberIds: memberIds ?? this.memberIds,
      );
}
