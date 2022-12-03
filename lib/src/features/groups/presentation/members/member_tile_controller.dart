import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_member.dart';

final memberTileControllerProvider = StateNotifierProvider.family
    .autoDispose<MemberTileController, AsyncValue, String>((ref, userId) {
  return MemberTileController(
    groupsService: ref.watch(groupsServiceProvider),
    groupsRepository: ref.watch(groupsRepositoryProvider),
  );
});

class MemberTileController extends StateNotifier<AsyncValue> {
  final GroupsService groupsService;
  final GroupsRepository groupsRepository;

  MemberTileController({
    required this.groupsService,
    required this.groupsRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> updateRole(Member member, MemberRole? role) async {
    assert(role == null || !role.isOwner);
    if (role == null) return removeMember(member);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final group = await groupsRepository.fetchGroup(member.groupId);
      final copy = group!.setMember(member.setRole(role));
      return groupsRepository.updateGroup(copy);
    });
  }

  Future<void> removeMember(Member member) async {
    assert(!member.role.isOwner);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final group = await groupsRepository.fetchGroup(member.groupId);
      final copy = group!.removeMemberById(member.id);
      return groupsRepository.updateGroup(copy);
    });
  }

  Future<void> transferOwnership(Member member) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => groupsService.transferOwnership(member),
    );
  }
}
