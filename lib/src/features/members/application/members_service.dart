import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/members/data/members_repository.dart';
import 'package:kfazer3/src/features/members/domain/member.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';

final membersServiceProvider = Provider<MembersService>((ref) {
  return MembersService(ref);
});

class MembersService {
  final Ref ref;
  MembersService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  MembersRepository get membersRepository =>
      ref.read(membersRepositoryProvider);

  Future<void> transferOwnership(Member member) async {
    final user = authRepository.currentUser!;
    final owner = Member.fromAppUser(
      user,
      groupId: member.groupId,
      role: MemberRole.admin,
    );
    await membersRepository.transferOwnership(owner, member);
  }
}

//* Providers

final roleFromMembersProvider =
    Provider.family.autoDispose<MemberRole, List<Member>>(
  (ref, members) {
    final user = ref.watch(currentUserStateProvider);
    final member = members.firstWhere((member) => member.id == user.id);
    return member.role;
  },
);
