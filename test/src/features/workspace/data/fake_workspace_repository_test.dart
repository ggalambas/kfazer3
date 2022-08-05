import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/data/fake_workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';

void main() {
  FakeWorkspaceRepository makeWorkspaceRepository() =>
      FakeWorkspaceRepository(addDelay: false);

  group('FakeWorkspaceRepository', () {
    test('watchWorkspaceList emits global list', () {
      final workspaceRepository = makeWorkspaceRepository();
      expect(
        workspaceRepository.watchWorkspaceList(),
        emits(kTestWorkspaces),
      );
    });
    test('watchWorkspace(0) emits first item', () {
      final workspaceRepository = makeWorkspaceRepository();
      expect(
        workspaceRepository.watchWorkspace('0'),
        emits(kTestWorkspaces.first),
      );
    });

    test('watchWorkspace(-1) emits null', () {
      final workspaceRepository = makeWorkspaceRepository();
      expect(
        workspaceRepository.watchWorkspace('-1'),
        emits(null),
      );
    });
    test('workspace updates', () async {
      final workspaceRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      final updatedWorkspace = workspace
          .updateTitle('New title')
          .updateDescription('New description')
          .updatePlan(WorkspacePlan.standard)
          .updateMotivationalMessages([]);
      await workspaceRepository.updateWorkspace(updatedWorkspace);
      expect(
        workspaceRepository.watchWorkspace(workspace.id),
        emits(updatedWorkspace),
      );
    });
    test('workspace disappears after delete', () async {
      final workspaceRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      await workspaceRepository.deleteWorkspace(workspace.id);
      expect(
        workspaceRepository.watchWorkspace(workspace.id),
        emits(null),
      );
    });
    test('workspace disappears after leave', () async {
      final workspaceRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      await workspaceRepository.leaveWorkspace(workspace.id);
      expect(
        workspaceRepository.watchWorkspace(workspace.id),
        emits(null),
      );
    });
    test('leave after dispose throws exception', () {
      final workspaceRepository = makeWorkspaceRepository();
      workspaceRepository.dispose();
      expect(
        () => workspaceRepository.leaveWorkspace(kTestWorkspaces.first.id),
        throwsStateError,
      );
    });
  });
}
