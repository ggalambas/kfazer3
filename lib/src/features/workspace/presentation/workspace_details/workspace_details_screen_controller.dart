import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

final workspaceDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<WorkspaceDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspaceRepositoryProvider);
    return WorkspaceDetailsScreenController(repository);
  },
);

class WorkspaceDetailsScreenController extends StateNotifier<AsyncValue> {
  final WorkspaceRepository _workspaceRepository;

  WorkspaceDetailsScreenController(this._workspaceRepository)
      : super(const AsyncValue.data(null));

  Future<bool> deleteWorkspace(WorkspaceId workspaceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _workspaceRepository.deleteWorkspace(workspaceId),
    );
    return !state.hasError;
  }
}
