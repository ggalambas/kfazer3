import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final motivationEditScreenControllerProvider = StateNotifierProvider
    .autoDispose<MotivationEditScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspacesRepositoryProvider);
    return MotivationEditScreenController(repository);
  },
);

class MotivationEditScreenController extends StateNotifier<AsyncValue>
    with MotivationValidators {
  final WorkspacesRepository _workspaceRepository;

  MotivationEditScreenController(this._workspaceRepository)
      : super(const AsyncValue.data(null));

  Future<void> save(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _workspaceRepository.updateWorkspace(workspace));
  }
}

mixin MotivationValidators {
  final messageSubmitValidators = [
    NonEmptyStringValidator('Message can\'t be empty'.hardcoded),
  ];
}

extension MotivationValidatorsText on MotivationValidators {
  String? messageErrorText(String name) => messageSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(name))
      ?.errorText;
}
