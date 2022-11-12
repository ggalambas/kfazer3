import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

final groupListControllerProvider =
    StateNotifierProvider.autoDispose<GroupListController, AsyncValue>(
  (ref) {
    return GroupListController(
      groupsService: ref.watch(groupsServiceProvider),
    );
  },
);

class GroupListController extends StateNotifier<AsyncValue> {
  final GroupsService groupsService;

  GroupListController({required this.groupsService})
      : super(const AsyncValue.data(null));

  Future<bool> leaveGroup(Group group) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => groupsService.leaveGroup(group));
    return !state.hasError;
  }
}
