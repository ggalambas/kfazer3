import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_member.dart';

final memberTileControllerProvider = StateNotifierProvider.family
    .autoDispose<MemberTileController, AsyncValue, String>((ref, userId) {
  return MemberTileController(
    groupsService: ref.watch(groupsServiceProvider),
  );
});

class MemberTileController extends StateNotifier<AsyncValue> {
  final GroupsService groupsService;

  MemberTileController({required this.groupsService})
      : super(const AsyncValue.data(null));

  Future<bool> updateRole(Member member, MemberRole role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsService.setMember(member.setRole(role)),
    );
    return !state.hasError;
  }
}
