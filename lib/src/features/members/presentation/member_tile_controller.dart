import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/members/application/members_service.dart';
import 'package:kfazer3/src/features/members/data/members_repository.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/features/members/domain/mutable_member.dart';

final memberTileControllerProvider = StateNotifierProvider.family
    .autoDispose<MemberTileController, AsyncValue, String>((ref, userId) {
  return MemberTileController(
    membersService: ref.watch(membersServiceProvider),
    membersRepository: ref.watch(membersRepositoryProvider),
  );
});

class MemberTileController extends StateNotifier<AsyncValue> {
  final MembersService membersService;
  final MembersRepository membersRepository;

  MemberTileController({
    required this.membersService,
    required this.membersRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> turnAdmin(Member member) {
    assert(member.role.isMember);
    return _updateRole(member, MemberRole.admin);
  }

  Future<void> revokeAdmin(Member member) {
    assert(member.role.isAdmin);
    return _updateRole(member, MemberRole.member);
  }

  Future<void> _updateRole(Member member, MemberRole role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final copy = member.setRole(role);
      await membersRepository.setMember(copy);
    });
  }

  Future<void> removeMember(Member member) async {
    assert(!member.role.isOwner);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await membersRepository.removeMember(member);
    });
  }

  Future<void> transferOwnership(Member member) async {
    assert(member.role.isMember || member.role.isAdmin);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await membersService.transferOwnership(member);
    });
  }
}
