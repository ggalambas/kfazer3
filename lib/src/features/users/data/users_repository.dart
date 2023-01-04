import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'fake_users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) {
    final repository = FakeUsersRepository(addDelay: addRepositoryDelay);
    ref.onDispose(repository.dispose);
    return repository;
  },
);

abstract class UsersRepository {
  Stream<AppUser?> watchUser(UserId userId);
  Stream<List<AppUser>> watchUserList(List<UserId> userIds);
}

final userStreamProvider = StreamProvider.family<AppUser?, UserId>(
  (ref, userId) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.watchUser(userId);
  },
);

final userListStreamProvider = StreamProvider.family<List<AppUser>, Group>(
  (ref, group) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.watchUserList(group.userIds);
  },
);
