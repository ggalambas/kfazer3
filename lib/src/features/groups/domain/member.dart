import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'member_role.dart';

/// Class representing the group member information
class Member {
  final UserId userId;
  final GroupId groupId;
  final MemberRole role;
  final DateTime inviteDate;
  final DateTime? joiningDate;

  const Member({
    required this.userId,
    required this.groupId,
    required this.role,
    required this.inviteDate,
    required this.joiningDate,
  });
}
