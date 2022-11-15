import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'group_plan.dart';

enum MemberRole { owner, admin, member, pending }

/// Class representing a group.
class Group with EquatableMixin {
  /// Unique group id
  final String id;
  final String title;
  final String? description;
  final String? photoUrl;
  final List<String> motivationalMessages;
  final GroupPlan plan;
  final List<PhoneNumber> pendingMembersPhoneNumber;
  final Map<String, MemberRole> memberRoles;

  const Group({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    this.motivationalMessages = const [],
    required this.plan,
    this.pendingMembersPhoneNumber = const [],
    required this.memberRoles,
  });

  @override
  List<Object?> get props => [id];
}

extension GroupMembers on Group {
  List<String> get memberIds => memberRoles.keys.toList();
  MemberRole memberRole(String memberId) {
    assert(memberRoles.containsKey(memberId));
    return memberRoles[memberId]!;
  }
}
