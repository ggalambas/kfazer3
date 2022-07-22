import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

import 'fake_workspaces_repository.dart';

abstract class WorkspacesRepository {
  Stream<List<Workspace>> watchWorkspaceList();
  Stream<Workspace?> watchWorkspace(WorkspaceId id);
}

final workspacesRepositoryProvider = Provider<WorkspacesRepository>(
  //TODO replace with real repository
  (ref) => FakeWorkspacesRepository(),
);

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
