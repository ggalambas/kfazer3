import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

final pendingGroupControllerProvider = StateNotifierProvider.family
    .autoDispose<PendingGroupController, AsyncValue<bool?>, String>(
  (ref, gorupId) => PendingGroupController(
    groupsService: ref.watch(groupsServiceProvider),
  ),
);

class PendingGroupController extends StateNotifier<AsyncValue<bool?>> {
  final GroupsService groupsService;

  PendingGroupController({required this.groupsService})
      : super(const AsyncValue.data(null));

  Future<bool> acceptInvite(Group group) async {
    state = const AsyncValue.data(true);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await groupsService.joinGroup(group);
      return null;
    });
    return !state.hasError;
  }

  Future<bool> declineInvite(Group group) async {
    state = const AsyncValue.data(false);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await groupsService.leaveGroup(group.id);
      return null;
    });
    return !state.hasError;
  }
}
