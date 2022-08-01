import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

final workspaceDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<WorkspaceDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspacesRepositoryProvider);
    return WorkspaceDetailsScreenController(repository);
  },
);

class WorkspaceDetailsScreenController extends StateNotifier<AsyncValue> {
  final WorkspacesRepository _workspacesRepository;

  WorkspaceDetailsScreenController(this._workspacesRepository)
      : super(const AsyncValue.data(null));

  Future<bool> deleteWorkspace(WorkspaceId workspaceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _workspacesRepository.deleteWorkspace(workspaceId),
    );
    return !state.hasError;
  }
}
