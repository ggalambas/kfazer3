import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
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
  final WorkspacesRepository _workspacesRepository;

  WorkspaceEditScreenController(this._workspacesRepository)
      : super(const AsyncValue.data(null));

  Future<void> save(Workspace workspace, Uint8List? imageBytes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _workspacesRepository.updateWorkspace(workspace),
    );
    //TODO save workspace image

    // save image into storage
    // get image url
    // update workspace photoUrl
    // update workspace
  }
}

mixin WorkspaceValidators {
  List<StringValidator> titleSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidTitleEmpty),
      ];

  List<StringValidator> descriptionSubmitValidators(BuildContext context) => [];
}

extension WorkspaceValidatorsText on WorkspaceValidators {
  String? titleErrorText(BuildContext context, String name) =>
      titleSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;

  String? descriptionErrorText(BuildContext context, String name) =>
      descriptionSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
