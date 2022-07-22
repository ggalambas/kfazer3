import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import 'fake_users_repository.dart';

abstract class UsersRepository {
  Future<List<AppUser>> fetchUserList();
  Future<AppUser?> fetchUser(String id);
}

final usersRepositoryProvider = Provider<UsersRepository>(
  //TODO replace with real repository
  (ref) => FakeUsersRepository(),
);

final userListFutureProvider = FutureProvider.autoDispose<List<AppUser>>(
  (ref) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.fetchUserList();
  },
);

final userFutureProvider = FutureProvider.autoDispose.family<AppUser?, String>(
  (ref, id) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.fetchUser(id);
  },
);
