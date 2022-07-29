import 'package:kfazer3/src/features/workspace/domain/preferences.dart';

/// * The workspace identifier is an important concept and can have its own type.
typedef WorkspaceId = String;

/// Class representing a workspace.
class Workspace {
  /// Unique workspace id
  final WorkspaceId id;
  final String title;
  final String description;
  final String? photoUrl;
  final List<String> motivationalMessages;
  final WorkspacePlan plan;

  const Workspace({
    required this.id,
    required this.title,
    required this.description,
    this.photoUrl,
    this.motivationalMessages = const [],
    this.plan = WorkspacePlan.family,
  });
}
