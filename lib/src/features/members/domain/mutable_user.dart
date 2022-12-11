import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/features/members/domain/user.dart';

/// Helper extension used to update a user
extension MutableUser on User {
  /// If a role with the given groupId is found, remove it
  User removeRoleByGroupId(GroupId groupId) {
    final copy = Map<GroupId, MemberRole>.from(roles);
    copy.remove(groupId);
    return copyWith(roles: copy);
  }

  /// Add a role to the user by *overriding* the role if it already exists
  User setRole(GroupId groupId, MemberRole role) {
    final copy = Map<GroupId, MemberRole>.from(roles);
    copy[groupId] = role;
    return copyWith(roles: copy);
  }

  User copyWith({
    String? id,
    String? name,
    PhoneNumber? phoneNumber,
    String? photoUrl,
    bool nullablePhotoUrl = false,
    Map<GroupId, MemberRole>? roles,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        photoUrl: nullablePhotoUrl ? photoUrl : (photoUrl ?? this.photoUrl),
        roles: roles ?? this.roles,
      );
}
