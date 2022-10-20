import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/test.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

import 'fake_tasks_repository.dart';

final tasksRepositoryProvider = Provider<FakeTasksRepository>(
  (ref) {
    final repository = FakeTasksRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

final filteredTaskListStreamProvider =
    StreamProvider.family<List<Task>, TaskState>(
  (ref, taskState) {
    final tasksRepository = ref.watch(tasksRepositoryProvider);
    return tasksRepository.watchTaskListFilteredBy(taskState);
  },
);

final taskProvider = StreamProvider.autoDispose.family<Task?, TaskId>(
  (ref, id) {
    final tasksRepository = ref.watch(tasksRepositoryProvider);
    return tasksRepository.watchTask(id);
  },
);
