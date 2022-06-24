import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

class FakeWorkspacesRepository {
  final List<Workspace> _workspaces = kTestWorkspaces;

  Stream<List<Workspace>> watchWorkspaceList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _workspaces;
  }

  Stream<Workspace?> watchWorkspace(WorkspaceId id) =>
      watchWorkspaceList().map((workspaces) =>
          workspaces.firstWhereOrNull((workspace) => workspace.id == id));
}

final workspacesRepositoryProvider = Provider<FakeWorkspacesRepository>(
  (ref) => FakeWorkspacesRepository(),
);

final workspaceListStreamProvider = StreamProvider.autoDispose<List<Workspace>>(
  (ref) {
    final workspacesRepository = ref.watch(workspacesRepositoryProvider);
    return workspacesRepository.watchWorkspaceList();
  },
);

final workspaceProvider =
    StreamProvider.autoDispose.family<Workspace?, WorkspaceId>(
  (ref, id) {
    final workspacesRepository = ref.watch(workspacesRepositoryProvider);
    return workspacesRepository.watchWorkspace(id);
  },
);
