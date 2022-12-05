import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final motivationEditControllerProvider =
    StateNotifierProvider.autoDispose<MotivationEditController, AsyncValue>(
  (ref) => MotivationEditController(
    groupsRepository: ref.watch(groupsRepositoryProvider),
  ),
);

class MotivationEditController extends StateNotifier<AsyncValue>
    with MotivationValidators {
  final GroupsRepository groupsRepository;

  MotivationEditController({required this.groupsRepository})
      : super(const AsyncValue.data(null));

  Future<void> save(Group group) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsRepository.updateGroup(group),
    );
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
