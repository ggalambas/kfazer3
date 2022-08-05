import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/data/fake_auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/domain/updatable_app_user.dart';

void main() {
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  const testName = 'Jimmy Hawkins';
  final testUser = AppUser(
    id: testPhoneNumber.entire(),
    phoneNumber: testPhoneNumber,
    name: testName,
  );
  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);
  group('FakeAuthRepository', () {
    test('currentUser is not null', () {
      final authRepository = makeAuthRepository();
      expect(authRepository.currentUser, kTestUsers.first);
      expect(authRepository.authStateChanges(), emits(kTestUsers.first));
    });
    test('currentUser is null after sign out', () async {
      final authRepository = makeAuthRepository();
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('currentUser is null after send sms code', () async {
      final authRepository = makeAuthRepository();
      await authRepository.signOut();
      authRepository.sendSmsCode(testPhoneNumber);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('currentUser is not null after sign in', () async {
      final authRepository = makeAuthRepository();
      final user = kTestUsers.first;
      await authRepository.signOut();
      await authRepository.verifySmsCode(user.phoneNumber, '123456');
      expect(authRepository.currentUser, user);
      expect(authRepository.authStateChanges(), emits(user));
    });
    test('currentUser is null after first time sign in', () async {
      final authRepository = makeAuthRepository();
      await authRepository.signOut();
      await authRepository.verifySmsCode(testPhoneNumber, '123456');
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('currentUser is not null after registration', () async {
      final authRepository = makeAuthRepository();
      await authRepository.signOut();
      await authRepository.createUser(testPhoneNumber, testName);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });
    test('currentUser is null after delete', () async {
      final authRepository = makeAuthRepository();
      await authRepository.deleteUser();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });
    test('currentUser updates', () async {
      final authRepository = makeAuthRepository();
      final updatedUser = kTestUsers.first
          .updatePhoneNumber(PhoneNumber('+351', '961234578'))
          .updateName('Jimbo');
      await authRepository.updateUser(updatedUser);
      expect(authRepository.currentUser, updatedUser);
      expect(authRepository.authStateChanges(), emits(updatedUser));
    });
    test('sign out after dispose throws exception', () {
      final authRepository = makeAuthRepository();
      authRepository.dispose();
      expect(
        authRepository.signOut,
        throwsStateError,
      );
    });
  });
}
