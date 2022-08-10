import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeWorkspaceRepository implements WorkspaceRepository {
  // final _workspaces = InMemoryStore<List<Workspace>>([]);
  final _workspaces = InMemoryStore<List<Workspace>>(kTestWorkspaces);
  void dispose() => _workspaces.close();

  final bool addDelay;
  FakeWorkspaceRepository({this.addDelay = true});

  @override
  Stream<List<Workspace>> watchWorkspaceList() async* {
    await delay(addDelay);
    yield* _workspaces.stream;
  }

  @override
  Stream<Workspace?> watchWorkspace(WorkspaceId id) async* {
    yield* watchWorkspaceList().map(
      (workspaces) => workspaces.firstWhereOrNull(
        (workspace) => workspace.id == id,
      ),
    );
  }

  @override
  Future<String> createWorkspace(
    String title,
    List<String> motivationalMessages,
    WorkspacePlan plan,
    List<PhoneNumber> phoneNumbers,
  ) async {
    //TODO what to do with the invites (phoneNumbers)
    await delay(addDelay);
    // First, get the workspace list
    final workspaces = _workspaces.value;
    // Then, add the workspace
    final workspace = Workspace(
      id: '${workspaces.length}',
      title: title,
      motivationalMessages: motivationalMessages,
      plan: plan,
    );
    workspaces.add(workspace);
    // Finally, update the notification list data (will emit a new value)
    _workspaces.value = workspaces;
    return workspace.id;
  }

  @override
  Future<void> updateWorkspace(Workspace workspace) async {
    await delay(addDelay);
    // First, get the workspace list
    final workspaces = _workspaces.value;
    // Then, change the workspace
    final i = workspaces.indexWhere((ws) => workspace.id == ws.id);
    workspaces[i] = workspace;
    // Finally, update the workspace list data (will emit a new value)
    _workspaces.value = workspaces;
  }

  @override
  Future<void> deleteWorkspace(WorkspaceId id) async {
    await delay(addDelay);
    // First, get the workspace list
    final workspaces = _workspaces.value;
    // Then, delete the workspace
    workspaces.removeWhere((ws) => id == ws.id);
    // Finally, update the workspace list data (will emit a new value)
    _workspaces.value = workspaces;
  }

  @override
  Future<void> leaveWorkspace(WorkspaceId id) => deleteWorkspace(id);
}
