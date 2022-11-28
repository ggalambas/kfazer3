import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import 'member_role.dart';

/// A user along with a role that can be added to a group
class Member {
  final UserId id;
  final MemberRole role;

  Member({required this.id, required this.role});
}
