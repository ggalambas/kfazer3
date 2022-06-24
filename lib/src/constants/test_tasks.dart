import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

/// Test tasks to be used until a data source is implemented
const kTestTasks = [
  Task(
    id: '1',
    workspaceId: '1',
    description: 'Description of task 1',
    state: TaskState.active,
  ),
  Task(
    id: '2',
    workspaceId: '1',
    description: 'Description of task 2',
    state: TaskState.active,
  ),
  Task(
    id: '3',
    workspaceId: '1',
    description: 'Description of task 3',
    state: TaskState.active,
  ),
  Task(
    id: '4',
    workspaceId: '1',
    description: 'Description of task 4',
    state: TaskState.scheduled,
  ),
  Task(
    id: '5',
    workspaceId: '1',
    description: 'Description of task 5',
    state: TaskState.archived,
  ),
  Task(
    id: '6',
    workspaceId: '1',
    description: 'Description of task 6',
    state: TaskState.archived,
  ),
  Task(
    id: '7',
    workspaceId: '1',
    description: 'Description of task 7',
    state: TaskState.archived,
  ),
  Task(
    id: '8',
    workspaceId: '1',
    description: 'Description of task 8',
    state: TaskState.archived,
  ),
];
