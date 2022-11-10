import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

final groupDetailsControllerProvider =
    StateNotifierProvider.autoDispose<GroupDetailsController, AsyncValue>(
  (ref) {
    final repository = ref.read(groupsRepositoryProvider);
    return GroupDetailsController(groupsRepository: repository);
  },
);

class GroupDetailsController extends StateNotifier<AsyncValue> {
  final GroupsRepository groupsRepository;

  GroupDetailsController({required this.groupsRepository})
      : super(const AsyncValue.data(null));

  Future<bool> deleteGroup(GroupId groupId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsRepository.deleteGroup(groupId),
    );
    return !state.hasError;
  }
}
