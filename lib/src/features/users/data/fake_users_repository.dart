import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'users_repository.dart';

class FakeUsersRepository implements UsersRepository {
  // final _users = InMemoryStore<List<AppUser>>([]);
  final _users = InMemoryStore<Map<AppUser, List<GroupId>>>(kTestUsers);
  void dispose() => _users.close();

  final bool addDelay;
  FakeUsersRepository({this.addDelay = true});

  @override
  Stream<List<AppUser>> watchGroupUsers(GroupId groupId) async* {
    await delay(addDelay);
    yield* _users.stream.map(
      (userMap) => userMap.keys
          .where((user) => userMap[user]!.contains(groupId))
          .toList(),
    );
  }

  @override
  Stream<AppUser?> watchUser(String id) async* {
    await delay(addDelay);
    yield* _users.stream.map(
      (userMap) => userMap.keys.firstWhereOrNull(
        (user) => user.id == id,
      ),
    );
  }
}
