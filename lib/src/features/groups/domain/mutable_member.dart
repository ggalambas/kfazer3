import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';

/// Helper extension used to update a member
extension MutableMember on Member {
  Member setRole(MemberRole role) {
    if (this.role.isPending && !role.isPending) {
      return _copyWith(role: role, joiningDate: DateTime.now());
    }
    return _copyWith(role: role);
  }

  Member _copyWith({
    MemberRole? role,
    DateTime? inviteDate,
    DateTime? joiningDate,
  }) =>
      Member(
        userId: userId,
        groupId: groupId,
        role: role ?? this.role,
        inviteDate: inviteDate ?? this.inviteDate,
        joiningDate: joiningDate ?? this.joiningDate,
      );
}
