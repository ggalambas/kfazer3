import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

import 'fake_workspaces_repository.dart';

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => FakeWorkspaceRepository(),
);

abstract class WorkspaceRepository {
  Stream<List<Workspace>> watchWorkspaceList();
  Stream<Workspace?> watchWorkspace(WorkspaceId id);
  Future<void> updateWorkspace(Workspace workspace);
  Future<void> deleteWorkspace(WorkspaceId id);
  Future<void> leaveWorkspace(WorkspaceId id);
}

//* Providers

final workspaceListStreamProvider = StreamProvider.autoDispose<List<Workspace>>(
  (ref) {
    final workspaceRepository = ref.watch(workspaceRepositoryProvider);
    return workspaceRepository.watchWorkspaceList();
  },
);

final workspaceStreamProvider =
    StreamProvider.autoDispose.family<Workspace?, WorkspaceId>(
  (ref, id) {
    final workspaceRepository = ref.watch(workspaceRepositoryProvider);
    return workspaceRepository.watchWorkspace(id);
  },
);
