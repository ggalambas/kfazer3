import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';

final groupPreferencesControllerProvider =
    StateNotifierProvider.autoDispose<GroupPreferencesController, AsyncValue>(
  (ref) => GroupPreferencesController(
    groupsRepository: ref.watch(groupsRepositoryProvider),
  ),
);

class GroupPreferencesController extends StateNotifier<AsyncValue> {
  final GroupsRepository groupsRepository;

  GroupPreferencesController({required this.groupsRepository})
      : super(const AsyncValue.data(null));

  Future<void> changePlan(Group group, GroupPlan plan) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final newGroup = group.setPlan(plan);
      return groupsRepository.updateGroup(newGroup);
    });
  }
}
