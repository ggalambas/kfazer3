import 'dart:math';

import 'package:kfazer3/src/constants/test_projects.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

/// Test tasks to be used until a data source is implemented
List<Task> get kTestTasks => [..._kTestTasks];
final _kTestTasks = List.generate(
  100,
  (i) {
    final state = TaskState.values[Random().nextInt(TaskState.values.length)];
    return Task(
      id: i.toString(),
      workspaceId: Random().nextInt(kTestProjects.length).toString(),
      description: 'Description of task $i',
      state: state,
      startDate: state == TaskState.scheduled
          ? DateTime.now().add(const Duration(days: 1))
          : null,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      conclusionDate: state == TaskState.completed ? DateTime.now() : null,
    );
  },
);
