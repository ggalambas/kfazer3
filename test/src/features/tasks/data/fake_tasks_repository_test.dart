import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_tasks.dart';
import 'package:kfazer3/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

void main() {
  FakeTasksRepository makeTasksRepository() =>
      FakeTasksRepository(addDelay: false);

  group('FakeTasksRepository', () {
    test('watchTaskList emits global list', () {
      final workspaceRepository = makeTasksRepository();
      expect(
        workspaceRepository.watchTaskList(),
        emits(kTestTasks),
      );
    });
    test('watchTaskListFilteredBy emits filtered list', () {
      final workspaceRepository = makeTasksRepository();
      const state = TaskState.active;
      expect(
        workspaceRepository.watchTaskListFilteredBy(state),
        emits(kTestTasks.where((task) => task.state == state)),
      );
    });
    test('watchTask(0) emits first item', () {
      final workspaceRepository = makeTasksRepository();
      expect(
        workspaceRepository.watchTask('0'),
        emits(kTestTasks.first),
      );
    });
    test('watchTask(-1) emits null', () {
      final workspaceRepository = makeTasksRepository();
      expect(
        workspaceRepository.watchTask('-1'),
        emits(null),
      );
    });
    // test('createTask after dispose throws exception', () {
    //   final workspaceRepository = makeTasksRepository();
    //   workspaceRepository.dispose();
    //   expect(
    //     () => workspaceRepository.createTask(/* task */),
    //     throwsStateError,
    //   );
    // });
  });
}
