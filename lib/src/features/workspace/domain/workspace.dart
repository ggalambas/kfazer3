import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';

/// * The workspace identifier is an important concept and can have its own type.
typedef WorkspaceId = String;

/// Class representing a workspace.
class Workspace with EquatableMixin {
  /// Unique workspace id
  final WorkspaceId id;
  final String title;
  final String? description;
  final String? photoUrl;
  final List<String> motivationalMessages;
  final WorkspacePlan plan;

  const Workspace({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    required this.motivationalMessages,
    required this.plan,
  });

  @override
  String toString() {
    return 'Workspace(id: $id, title: $title, description: $description, photoUrl: $photoUrl, motivationalMessages: $motivationalMessages, plan: $plan)';
  }

  @override
  List<Object?> get props => [id];
}
