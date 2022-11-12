import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';

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

  Future<bool> deleteGroup(String groupId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsRepository.deleteGroup(groupId),
    );
    return !state.hasError;
  }
}
