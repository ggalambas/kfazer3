import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final motivationEditScreenControllerProvider = StateNotifierProvider
    .autoDispose<MotivationEditScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(workspaceRepositoryProvider);
    return MotivationEditScreenController(workspaceRepository: repository);
  },
);

class MotivationEditScreenController extends StateNotifier<AsyncValue>
    with MotivationValidators {
  final WorkspaceRepository workspaceRepository;

  MotivationEditScreenController({required this.workspaceRepository})
      : super(const AsyncValue.data(null));

  Future<void> save(Workspace workspace) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => workspaceRepository.updateWorkspace(workspace));
  }
}

mixin MotivationValidators {
  List<StringValidator> messageSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidMessageEmpty),
      ];
}

extension MotivationValidatorsText on MotivationValidators {
  String? messageErrorText(BuildContext context, String name) =>
      messageSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
