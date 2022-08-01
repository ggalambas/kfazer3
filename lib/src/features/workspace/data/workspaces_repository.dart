import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

import 'fake_workspaces_repository.dart';

final workspacesRepositoryProvider = Provider<WorkspacesRepository>(
  (ref) => FakeWorkspacesRepository(),
);

abstract class WorkspacesRepository {
  Stream<List<Workspace>> watchWorkspaceList();
  Stream<Workspace?> watchWorkspace(WorkspaceId id);
  Future<void> updateWorkspace(Workspace workspace);
  Future<void> deleteWorkspace(WorkspaceId id);
  Future<void> leaveWorkspace(WorkspaceId id);
}

//* Providers

final workspaceListStreamProvider = StreamProvider.autoDispose<List<Workspace>>(
  (ref) {
    final workspacesRepository = ref.watch(workspacesRepositoryProvider);
    return workspacesRepository.watchWorkspaceList();
  },
);

final workspaceStreamProvider =
    StreamProvider.autoDispose.family<Workspace?, WorkspaceId>(
  (ref, id) {
    final workspacesRepository = ref.watch(workspacesRepositoryProvider);
    return workspacesRepository.watchWorkspace(id);
  },
);
