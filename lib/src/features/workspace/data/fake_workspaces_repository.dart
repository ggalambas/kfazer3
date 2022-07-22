import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

class FakeWorkspacesRepository extends WorkspacesRepository {
  final List<Workspace> _workspaces = kTestWorkspaces;

  @override
  Stream<List<Workspace>> watchWorkspaceList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _workspaces;
  }

  @override
  Stream<Workspace?> watchWorkspace(WorkspaceId id) {
    return watchWorkspaceList().map(
      (workspaces) => workspaces.firstWhereOrNull(
        (workspace) => workspace.id == id,
      ),
    );
  }
}
