import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import 'fake_users_repository.dart';

abstract class UsersRepository {
  Future<List<AppUser>> fetchUserList();
  Stream<AppUser?> watchUser(String id);
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

final userStreamProvider = StreamProvider.family<AppUser?, String>(
  (ref, id) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.watchUser(id);
  },
);
