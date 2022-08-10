import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

import 'fake_workspaces_repository.dart';

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) {
    final repository = FakeWorkspaceRepository();
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class WorkspaceRepository {
  Stream<List<Workspace>> watchWorkspaceList();
  Stream<Workspace?> watchWorkspace(WorkspaceId id);
  Future<String> createWorkspace(
    String title,
    List<String> motivationalMessages,
    WorkspacePlan plan,
    List<PhoneNumber> phoneNumbers,
  ); //TODO test
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
