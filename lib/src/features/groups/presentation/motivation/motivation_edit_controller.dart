import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'motivation_validators.dart';

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

  Future<bool> save(GroupId groupId, List<String> messages) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return groupsRepository.updateMotivationalMessages(groupId, messages);
    });
    return !state.hasError;
  }
}
