import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/members/domain/user.dart';

import 'fake_users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => FakeUsersRepository(
    users: ref.watch(fakeUsersProvider),
    addDelay: addRepositoryDelay,
  ),
);

abstract class UsersRepository {
  Stream<User?> watchUser(UserId userId);
}

final userStreamProvider = StreamProvider.family<User?, UserId>(
  (ref, userId) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.watchUser(userId);
  },
);
