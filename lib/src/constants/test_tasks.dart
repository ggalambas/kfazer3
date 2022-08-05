import 'dart:math';

import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

/// Test tasks to be used until a data source is implemented
List<Task> get kTestTasks => [..._kTestTasks];
final _kTestTasks = List.generate(
  100,
  (i) => Task(
    id: i.toString(),
    workspaceId: Random().nextInt(kTestWorkspaces.length).toString(),
    description: 'Description of task $i',
    state: TaskState.values[Random().nextInt(TaskState.values.length)],
  ),
);
