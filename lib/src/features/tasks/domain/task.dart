import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

/// * The task identifier is an important concept and can have its own type.
typedef TaskId = String;

/// Class representing a task
class Task with TaskStateMixin {
  /// Unique product id
  final TaskId id;
  final WorkspaceId workspaceId;
  final String description;

  final DateTime startDate;
  final DateTime? dueDate;
  final DateTime? conclusionDate;
  // final String assigneeId;
  // final bool isPriority;

  @override
  final TaskState state;

  Task({
    required this.id,
    required this.workspaceId,
    required this.description,
    startDate,
    this.dueDate,
    this.conclusionDate,
    // required this.assigneeId,
    // required this.isPriority,
    required this.state,
  }) : startDate = startDate ?? DateTime.now();
}
