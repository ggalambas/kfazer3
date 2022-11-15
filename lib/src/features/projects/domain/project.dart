import 'package:equatable/equatable.dart';

/// Class representing a project.
class Project with EquatableMixin {
  /// Unique project id
  final String id;
  final String title;
  final String? description;

  final String groupId;

  const Project({
    required this.id,
    required this.title,
    this.description,
    required this.groupId,
  });

  @override
  List<Object?> get props => [id];
}
