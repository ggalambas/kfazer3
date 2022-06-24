import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

/// * The task identifier is an important concept and can have its own type.
typedef TaskId = String;

/// Class representing a task.
class Task with TaskStateMixin {
  /// Unique product id
  final TaskId id;
  final WorkspaceId workspaceId;
  final String description;
  @override
  final TaskState state;

  const Task({
    required this.id,
    required this.workspaceId,
    required this.description,
    required this.state,
  });
}
