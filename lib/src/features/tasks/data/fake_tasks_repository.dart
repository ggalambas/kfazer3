import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_tasks.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeTasksRepository {
  // final _tasks = InMemoryStore<List<Task>>([]);
  final _tasks = InMemoryStore<List<Task>>(kTestTasks);
  void dispose() => _tasks.close();

  final bool addDelay;
  FakeTasksRepository({this.addDelay = true});

  //! workspaceId

  Stream<List<Task>> watchTaskList() async* {
    await delay(addDelay);
    yield* _tasks.stream;
  }

  Stream<List<Task>> watchTaskListFilteredBy(TaskState taskState) =>
      watchTaskList().map(
          (tasks) => tasks.where((task) => task.state == taskState).toList());

  Stream<Task?> watchTask(TaskId id) => watchTaskList()
      .map((tasks) => tasks.firstWhereOrNull((task) => task.id == id));
}
