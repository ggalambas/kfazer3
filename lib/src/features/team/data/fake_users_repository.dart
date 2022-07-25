import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/team/data/users_repository.dart';

class FakeUsersRepository extends UsersRepository {
  final List<AppUser> _users = kTestUsers;

  @override
  Future<List<AppUser>> fetchUserList() async {
    await Future.delayed(const Duration(seconds: 1));
    return _users;
  }

  @override
  Stream<AppUser?> watchUser(String id) async* {
    final userList = await fetchUserList();
    yield userList.firstWhereOrNull((user) => user.id == id);
  }
}
