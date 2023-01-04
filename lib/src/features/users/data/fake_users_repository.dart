import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';
import 'package:rxdart/streams.dart';

import 'users_repository.dart';

class FakeUsersRepository implements UsersRepository {
  /// An InMemoryStore containing all the users.
  final _users = InMemoryStore<List<AppUser>>(kTestUsers);
  final bool addDelay;

  FakeUsersRepository({this.addDelay = true});
  void dispose() => _users.close();

  @override
  Stream<AppUser?> watchUser(UserId userId) async* {
    await delay(addDelay);
    yield* _users.stream.map(
      (users) => users.firstWhereOrNull(
        (user) => user.id == userId,
      ),
    );
  }

  @override
  Stream<List<AppUser>> watchUserList(List<UserId> userIds) =>
      CombineLatestStream.list<AppUser?>(userIds.map(watchUser)).map(
        (users) => users.where((user) => user != null).cast<AppUser>().toList(),
      );
}
