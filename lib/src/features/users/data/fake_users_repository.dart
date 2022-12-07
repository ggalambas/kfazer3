import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'users_repository.dart';

class FakeUsersRepository implements UsersRepository {
  // final _users = InMemoryStore<List<AppUser>>([]);
  final _users = InMemoryStore<List<AppUser>>(kTestUsers);
  void dispose() => _users.close();

  final bool addDelay;
  FakeUsersRepository({this.addDelay = true});

  @override
  Stream<AppUser?> watchUser(String id) async* {
    await delay(addDelay);
    final userList = _users.value;
    yield userList.firstWhereOrNull((user) => user.id == id);
  }
}
