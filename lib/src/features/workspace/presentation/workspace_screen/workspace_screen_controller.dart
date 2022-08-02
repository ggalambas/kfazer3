import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

final workspaceScreenControllerProvider =
    StateNotifierProvider.autoDispose<WorkspaceScreenController, AsyncValue>(
  (ref) => WorkspaceScreenController(read: ref.read),
);

class WorkspaceScreenController extends StateNotifier<AsyncValue> {
  final Reader read;

  WorkspaceScreenController({required this.read})
      : super(const AsyncValue.data(null));

  WorkspaceRepository get repository => read(workspaceRepositoryProvider);

  Future<bool> leave(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.leaveWorkspace(workspace.id),
    );
    return !state.hasError;
  }
}
