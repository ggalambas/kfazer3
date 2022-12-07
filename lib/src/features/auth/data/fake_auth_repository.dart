import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  late final InMemoryStore<AppUser?> _authState;
  final bool addDelay;

  FakeAuthRepository({this.addDelay = true, bool startSignedIn = true})
      : _authState =
            InMemoryStore(startSignedIn ? kTestUsers.keys.first : null);

  void dispose() => _authState.close();

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;
  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> sendSmsCode(PhoneNumber phoneNumber) async {
    await delay(addDelay);
  }

  @override
  Future<void> verifySmsCode(PhoneNumber phoneNumber, String smsCode) async {
    await delay(addDelay);
    final user = kTestUsers.keys.firstWhereOrNull(
      (user) => user.phoneNumber == phoneNumber,
    );
    _authState.value = user;
  }

  @override
  Future<void> createUser(PhoneNumber phoneNumber, String displayName) async {
    await delay(addDelay);
    _authState.value = AppUser(
      id: phoneNumber.full,
      name: displayName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await delay(addDelay);
    _authState.value = user;
  }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  @override
  Future<void> deleteUser() => signOut();
}
