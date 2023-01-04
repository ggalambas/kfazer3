import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/member.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_member.dart';

final memberTileControllerProvider = StateNotifierProvider.family
    .autoDispose<MemberTileController, AsyncValue, String>((ref, userId) {
  return MemberTileController(
    groupsRepository: ref.watch(groupsRepositoryProvider),
    groupsService: ref.watch(groupsServiceProvider),
  );
});

class MemberTileController extends StateNotifier<AsyncValue> {
  final GroupsRepository groupsRepository;
  final GroupsService groupsService;

  MemberTileController({
    required this.groupsRepository,
    required this.groupsService,
  }) : super(const AsyncValue.data(null));

  Future<void> turnAdmin(Member member) {
    assert(member.role.isMember);
    return _updateMember(member, MemberRole.admin);
  }

  Future<void> revokeAdmin(Member member) {
    assert(member.role.isAdmin);
    return _updateMember(member, MemberRole.member);
  }

  Future<void> _updateMember(Member member, MemberRole role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final copy = member.setRole(role);
      await groupsRepository.setMember(copy);
    });
  }

  Future<void> removeMember(Member member) async {
    assert(!member.role.isOwner);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await groupsRepository.removeMember(member.groupId, member.userId);
    });
  }

  Future<void> transferOwnership(Member member) async {
    assert(member.role.isMember || member.role.isAdmin);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await groupsService.transferOwnership(member);
    });
  }
}
