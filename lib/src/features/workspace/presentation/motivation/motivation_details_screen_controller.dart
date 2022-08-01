import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

final motivationDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<MotivationDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspacesRepositoryProvider);
    return MotivationDetailsScreenController(repository);
  },
);

class MotivationDetailsScreenController extends StateNotifier<AsyncValue> {
  final WorkspacesRepository _workspacesRepository;

  MotivationDetailsScreenController(this._workspacesRepository)
      : super(const AsyncValue.data(null));

  Future<void> clearMessages(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _workspacesRepository
          .updateWorkspace(workspace.updateMotivationalMessages([])),
    );
  }
}
