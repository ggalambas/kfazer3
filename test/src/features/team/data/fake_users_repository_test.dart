import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/team/data/fake_users_repository.dart';

void main() {
  FakeUsersRepository makeUsersRepository() =>
      FakeUsersRepository(addDelay: false);

  group('FakeUsersRepository', () {
    test('fetchUserList returns global list', () async {
      final usersRepository = makeUsersRepository();
      expect(
        await usersRepository.fetchUserList(),
        kTestUsers,
      );
    });
    test('watchUser(+351900000000) emits first item', () {
      final usersRepository = makeUsersRepository();
      expect(
        usersRepository.watchUser('+351900000000'),
        emits(kTestUsers.first),
      );
    });
    test('watchUser(-1) emits null', () {
      final usersRepository = makeUsersRepository();
      expect(
        usersRepository.watchUser('-1'),
        emits(null),
      );
    });
    //TODO test dispose for users repo
    // test('fetchUserList after dispose throws exception', () async {
    //   final usersRepository = makeUsersRepository();
    //   usersRepository.dispose();
    //   expect(
    //     () async => await usersRepository.fetchUserList(),
    //     throwsStateError,
    //   );
    // });
  });
}
