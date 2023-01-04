import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';

import 'group_plan.dart';

/// * The group identifier is an important concept and can have its own type.
typedef GroupId = String;

/// Class representing a group.
class Group with EquatableMixin {
  /// Unique group id
  final GroupId id;
  final String name;
  final String description;
  final String? photoUrl;
  final GroupPlan plan;
  //TODO creation date?
  // final DateTime creationDate;

  /// All the members in the group, where:
  /// - key: user id
  /// - value: member
  final Map<UserId, Member> members;
  final Set<PhoneNumber> pendingMembersPhoneNumber;

  const Group({
    required this.id,
    required this.name,
    this.description = '',
    this.photoUrl,
    required this.plan,
    required this.members,
    this.pendingMembersPhoneNumber = const {},
  });

  @override
  List<Object?> get props => [id];
}

extension GroupMembers on Group {
  List<UserId> get userIds => members.keys.toList();
  Member member(UserId userId) => members[userId]!;
}
