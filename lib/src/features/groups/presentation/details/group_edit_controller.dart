import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final groupEditControllerProvider =
    StateNotifierProvider.autoDispose<GroupEditController, AsyncValue>(
  (ref) {
    final repository = ref.read(groupsRepositoryProvider);
    return GroupEditController(groupsRepository: repository);
  },
);

class GroupEditController extends StateNotifier<AsyncValue>
    with GroupValidators {
  final GroupsRepository groupsRepository;

  GroupEditController({required this.groupsRepository})
      : super(const AsyncValue.data(null));

  Future<void> save(Group group, Uint8List? imageBytes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsRepository.updateGroup(group),
    );
    //TODO save group image

    // save image into storage
    // get image url
    // update group photoUrl
    // update group
    //! update tests
  }
}

mixin GroupValidators {
  List<StringValidator> titleSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidTitleEmpty),
      ];

  List<StringValidator> descriptionSubmitValidators(BuildContext context) => [];
}

extension GroupValidatorsText on GroupValidators {
  String? titleErrorText(BuildContext context, String name) =>
      titleSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;

  String? descriptionErrorText(BuildContext context, String name) =>
      descriptionSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
