import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'group_plan.dart';
import 'member.dart';
import 'member_role.dart';

/// * The group identifier is an important concept and can have its own type.
typedef GroupId = String;

/// Class representing a group.
class Group with EquatableMixin {
  /// Unique group id
  final GroupId id;
  final String name;
  final String description;
  final String? photoUrl;
  final List<String> motivationalMessages;
  final GroupPlan plan;

  /// All the members in the group, where:
  /// - key: user id
  /// - value: role
  final Map<UserId, MemberRole> members;
  final Set<PhoneNumber> pendingMembersPhoneNumber;

  const Group({
    required this.id,
    required this.name,
    this.description = '',
    this.photoUrl,
    this.motivationalMessages = const [],
    required this.plan,
    required this.members,
    this.pendingMembersPhoneNumber = const {},
  });

  @override
  List<Object?> get props => [id];
}

extension GroupMembers on Group {
  List<Member> toMemberList() => members.entries
      .map((entry) => Member(id: entry.key, groupId: id, role: entry.value))
      .toList();
}
