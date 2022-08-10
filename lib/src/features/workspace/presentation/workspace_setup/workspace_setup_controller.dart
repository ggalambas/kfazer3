import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_details/workspace_edit_screen_controller.dart';

final workspaceSetupControllerProvider =
    StateNotifierProvider<WorkspaceSetupController, AsyncValue>(
  (ref) {
    final repository = ref.watch(workspaceRepositoryProvider);
    return WorkspaceSetupController(workspaceRepository: repository);
  },
);

class WorkspaceSetupController extends StateNotifier<AsyncValue>
    with WorkspaceValidators {
  final WorkspaceRepository workspaceRepository;

  WorkspaceSetupController({required this.workspaceRepository})
      : super(const AsyncValue.data(null));

  String? title;

  void saveTitle(String title) => this.title = title;
}
