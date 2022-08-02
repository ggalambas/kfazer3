import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/data/fake_workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';

void main() {
  WorkspaceRepository makeWorkspaceRepository() =>
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
      final authRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      final updatedWorkspace = workspace
          .updateTitle('New title')
          .updateDescription('New description')
          .updatePlan(WorkspacePlan.standard)
          .updateMotivationalMessages([]);
      await authRepository.updateWorkspace(updatedWorkspace);
      expect(
        authRepository.watchWorkspace(workspace.id),
        emits(updatedWorkspace),
      );
    });
    test('workspace disappears after delete', () async {
      final authRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      await authRepository.deleteWorkspace(workspace.id);
      expect(
        authRepository.watchWorkspace(workspace.id),
        emits(null),
      );
    });
    test('workspace disappears after leave', () async {
      final authRepository = makeWorkspaceRepository();
      final workspace = kTestWorkspaces.first;
      await authRepository.leaveWorkspace(workspace.id);
      expect(
        authRepository.watchWorkspace(workspace.id),
        emits(null),
      );
    });
  });
}
