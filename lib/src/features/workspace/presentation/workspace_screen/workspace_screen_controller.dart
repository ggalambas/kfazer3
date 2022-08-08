import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';

final workspaceScreenControllerProvider =
    StateNotifierProvider.autoDispose<WorkspaceScreenController, AsyncValue>(
  (ref) {
    final repository = ref.watch(workspaceRepositoryProvider);
    return WorkspaceScreenController(workspaceRepository: repository);
  },
);

class WorkspaceScreenController extends StateNotifier<AsyncValue> {
  final WorkspaceRepository workspaceRepository;

  WorkspaceScreenController({required this.workspaceRepository})
      : super(const AsyncValue.data(null));

  Future<bool> leave(String workspaceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => workspaceRepository.leaveWorkspace(workspaceId),
    );
    return !state.hasError;
  }
}
