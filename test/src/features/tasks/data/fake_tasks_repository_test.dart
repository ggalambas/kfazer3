@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_tasks.dart';
import 'package:kfazer3/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';

void main() {
  late FakeTasksRepository workspaceRepository;
  setUp(() => workspaceRepository = FakeTasksRepository(addDelay: false));
  tearDown(() => workspaceRepository.dispose());

  group('FakeTasksRepository', () {
    test('watchTaskList emits global list', () {
      expect(
        workspaceRepository.watchTaskList(),
        emits(kTestTasks),
      );
    });
    test('watchTaskListFilteredBy emits filtered list', () {
      const state = TaskState.active;
      expect(
        workspaceRepository.watchTaskListFilteredBy(state),
        emits(kTestTasks.where((task) => task.state == state)),
      );
    });
    test('watchTask(0) emits first item', () {
      expect(
        workspaceRepository.watchTask('0'),
        emits(kTestTasks.first),
      );
    });
    test('watchTask(-1) emits null', () {
      expect(
        workspaceRepository.watchTask('-1'),
        emits(null),
      );
    });
  });
}
