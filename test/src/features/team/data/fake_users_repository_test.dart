@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/team/data/fake_users_repository.dart';

void main() {
  late FakeUsersRepository usersRepository;
  setUp(() => usersRepository = FakeUsersRepository(addDelay: false));
  tearDown(() => usersRepository.dispose());

  group('FakeUsersRepository', () {
    test('fetchUserList returns global list', () async {
      expect(
        await usersRepository.fetchUserList(),
        kTestUsers,
      );
    });
    test('watchUser(+351900000000) emits first item', () {
      expect(
        usersRepository.watchUser('+351900000000'),
        emits(kTestUsers.first),
      );
    });
    test('watchUser(-1) emits null', () {
      expect(
        usersRepository.watchUser('-1'),
        emits(null),
      );
    });
  });
}
