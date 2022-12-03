import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'group_plan.dart';
import 'member.dart';
import 'member_role.dart';

/// Class representing a group.
class Group with EquatableMixin {
  /// Unique group id
  final String id;
  final String title;
  final String description;
  final String? photoUrl;
  final List<String> motivationalMessages;
  final GroupPlan plan;
  final List<PhoneNumber> pendingMembersPhoneNumber;

  /// All the members in the group, where:
  /// - key: user id
  /// - value: role
  final Map<UserId, MemberRole> members;

  const Group({
    required this.id,
    required this.title,
    this.description = '',
    this.photoUrl,
    this.motivationalMessages = const [],
    required this.plan,
    this.pendingMembersPhoneNumber = const [],
    required this.members,
  });

  @override
  List<Object?> get props => [id];
}

extension GroupMembers on Group {
  List<Member> toMemberList() => members.entries
      .map((entry) => Member(id: entry.key, groupId: id, role: entry.value))
      .toList();
}
