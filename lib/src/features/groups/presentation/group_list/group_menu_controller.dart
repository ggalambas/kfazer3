import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

final groupMenuControllerProvider =
    StateNotifierProvider.autoDispose<GroupMenuController, AsyncValue>(
  (ref) {
    return GroupMenuController(
      groupsService: ref.watch(groupsServiceProvider),
    );
  },
);

class GroupMenuController extends StateNotifier<AsyncValue> {
  final GroupsService groupsService;

  GroupMenuController({required this.groupsService})
      : super(const AsyncValue.data(null));

  Future<void> leaveGroup(Group group) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => groupsService.leaveGroup(group));
  }
}
