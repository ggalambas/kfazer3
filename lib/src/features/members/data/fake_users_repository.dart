import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/members/domain/user.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'users_repository.dart';

typedef InMemoryUsers = InMemoryStore<List<User>>;

final fakeUsersProvider = Provider<InMemoryUsers>((ref) {
  final users = InMemoryUsers(kTestUsers);
  ref.onDispose(() => users.close());
  return users;
});

class FakeUsersRepository implements UsersRepository {
  /// An InMemoryStore containing all the users.
  final InMemoryUsers _users;
  final bool addDelay;

  FakeUsersRepository({
    required InMemoryUsers users,
    this.addDelay = true,
  }) : _users = users;

  @override
  Stream<User?> watchUser(UserId userId) async* {
    await delay(addDelay);
    yield* _users.stream.map(
      (users) => users.firstWhereOrNull(
        (user) => user.id == userId,
      ),
    );
  }
}
