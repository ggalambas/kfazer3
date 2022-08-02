import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/data/fake_workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';

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
  });
}
