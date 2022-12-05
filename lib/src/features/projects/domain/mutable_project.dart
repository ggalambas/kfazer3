import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

/// Helper extension used to update a group
extension MutableProject on Project {
  Project setId(String id) => copyWith(id: id);
  Project setTitle(String title) => copyWith(title: title);
  Project setDescription(String description) =>
      copyWith(description: description);

  /// If a member with the given userId is found, remove it
  Project removeMemberById(UserId memberId) {
    final copy = List<UserId>.from(members);
    copy.remove(memberId);
    return copyWith(members: copy);
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? members,
    String? groupId,
  }) =>
      Project(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        members: members ?? this.members,
        groupId: groupId ?? this.groupId,
      );
}
