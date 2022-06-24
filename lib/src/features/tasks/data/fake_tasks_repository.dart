import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/test_tasks.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

class FakeTasksRepository {
  final List<Task> _tasks = kTestTasks;

  //! workspaceId

  Stream<List<Task>> watchTaskList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _tasks;
  }

  Stream<List<Task>> watchTaskListFilteredBy(TaskState taskState) =>
      watchTaskList().map(
          (tasks) => tasks.where((task) => task.state == taskState).toList());

  Stream<Task?> watchTask(TaskId id) => watchTaskList()
      .map((tasks) => tasks.firstWhereOrNull((task) => task.id == id));
}

final tasksRepositoryProvider = Provider<FakeTasksRepository>(
  (ref) => FakeTasksRepository(),
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
