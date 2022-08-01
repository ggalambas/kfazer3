import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeWorkspacesRepository implements WorkspacesRepository {
  final _workspaces = InMemoryStore<List<Workspace>>(kTestWorkspaces);

  @override
  Stream<List<Workspace>> watchWorkspaceList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield* _workspaces.stream;
  }

  @override
  Stream<Workspace?> watchWorkspace(WorkspaceId id) {
    return watchWorkspaceList().map(
      (workspaces) => workspaces.firstWhereOrNull(
        (workspace) => workspace.id == id,
      ),
    );
  }

  @override
  Future<void> updateWorkspace(Workspace workspace) async {
    await Future.delayed(const Duration(seconds: 1));
    // First, get the workspace list
    final workspaces = _workspaces.value;
    // Then, change the workspace
    final i = workspaces.indexWhere((ws) => workspace.id == ws.id);
    workspaces[i] = workspace;
    // Finally, update the workspace list data (will emit a new value)
    _workspaces.value = workspaces;
  }

  @override
  Future<void> deleteWorkspace(WorkspaceId id) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
