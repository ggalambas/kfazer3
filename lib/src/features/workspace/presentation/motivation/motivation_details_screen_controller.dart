import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

final motivationDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<MotivationDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspaceRepositoryProvider);
    return MotivationDetailsScreenController(workspaceRepository: repository);
  },
);

class MotivationDetailsScreenController extends StateNotifier<AsyncValue> {
  final WorkspaceRepository workspaceRepository;

  MotivationDetailsScreenController({required this.workspaceRepository})
      : super(const AsyncValue.data(null));

  Future<void> clearMessages(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final updatedWorkspace = workspace.updateMotivationalMessages([]);
      return workspaceRepository.updateWorkspace(updatedWorkspace);
    });
  }
}
