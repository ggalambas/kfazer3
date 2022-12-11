import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';

/// Helper extension used to update a member
extension MutableMember on Member {
  Member setRole(MemberRole role) => Member(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        groupId: groupId,
        role: role,
      );
}
