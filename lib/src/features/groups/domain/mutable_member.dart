import 'package:kfazer3/src/features/groups/domain/member.dart';

import 'member_role.dart';

/// Helper extension used to update a member
extension MutableMember on Member {
  Member setRole(MemberRole newRole) =>
      Member(id: id, groupId: groupId, role: newRole);
}
