import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import 'fake_users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) {
    final repository = FakeUsersRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class UsersRepository {
  Stream<AppUser?> watchUser(String id);
}

final userStreamProvider = StreamProvider.family<AppUser?, String>(
  (ref, id) {
    final usersRepository = ref.watch(usersRepositoryProvider);
    return usersRepository.watchUser(id);
  },
);
