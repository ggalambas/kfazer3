import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final workspaceEditScreenControllerProvider = StateNotifierProvider.autoDispose<
    WorkspaceEditScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspacesRepositoryProvider);
    return WorkspaceEditScreenController(repository);
  },
);

class WorkspaceEditScreenController extends StateNotifier<AsyncValue>
    with WorkspaceValidators {
  final WorkspacesRepository _workspaceRepository;

  WorkspaceEditScreenController(this._workspaceRepository)
      : super(const AsyncValue.data(null));

  Future<void> save(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _workspaceRepository.updateWorkspace(workspace));
  }
}

mixin WorkspaceValidators {
  final titleSubmitValidators = [
    NonEmptyStringValidator('Title can\'t be empty'.hardcoded),
  ];

  final descriptionSubmitValidators = [];
}

extension WorkspaceValidatorsText on WorkspaceValidators {
  String? titleErrorText(String name) => titleSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(name))
      ?.errorText;

  String? descriptionErrorText(String name) => descriptionSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(name))
      ?.errorText;
}
