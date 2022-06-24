/// * The workspace identifier is an important concept and can have its own type.
typedef WorkspaceId = String;

/// Class representing a workspace.
class Workspace {
  /// Unique workspace id
  final WorkspaceId id;
  final String title;
  final String description;

  const Workspace({
    required this.id,
    required this.title,
    required this.description,
  });
}
