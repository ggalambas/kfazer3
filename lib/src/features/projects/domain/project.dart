import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

/// Class representing a project.
class Project with EquatableMixin {
  /// Unique project id
  final String id;
  final String title;
  final String description;

  //! while not discussed i'll leave it like this
  final List<UserId> members;

  final GroupId groupId;

  const Project({
    required this.id,
    required this.title,
    this.description = '',
    required this.members,
    required this.groupId,
  });

  @override
  List<Object?> get props => [id];
}
