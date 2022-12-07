import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/motivation/data/motivation_repository.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';

import 'motivation_validators.dart';

final motivationEditControllerProvider =
    StateNotifierProvider.autoDispose<MotivationEditController, AsyncValue>(
  (ref) => MotivationEditController(
    motivationRepository: ref.watch(motivationRepositoryProvider),
  ),
);

class MotivationEditController extends StateNotifier<AsyncValue>
    with MotivationValidators {
  final MotivationRepository motivationRepository;

  MotivationEditController({required this.motivationRepository})
      : super(const AsyncValue.data(null));

  Future<bool> save(GroupId groupId, Motivation motivation) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return motivationRepository.setMotivation(groupId, motivation);
    });
    return !state.hasError;
  }
}
