import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemorStore<AppUser?>(
    // null,
    AppUser(
      id: '912345678'.split('').reversed.join(),
      name: 'Tareco Buíto',
      phoneNumber: '912345678',
    ),
  );

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;
  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> sendSmsCode(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    if (currentUser == null) {
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> verifySmsCode(String phoneNumber, String smsCode) async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    if (currentUser == null) {
      // if user has account
      // await _signInWithPhoneNumber(phoneNumber);
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> createAccount(String phoneNumber, String displayName) async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    if (currentUser == null) {
      await _signInWithPhoneNumber(phoneNumber, displayName: displayName);
    } else {
      throw Exception();
    }
  }

  Future<void> _signInWithPhoneNumber(
    String phoneNumber, {
    String? displayName,
  }) async {
    if (currentUser == null) {
      _authState.value = AppUser(
        id: phoneNumber.split('').reversed.join(),
        name: displayName ?? 'Tareco Buíto',
        phoneNumber: phoneNumber,
      );
    }
  }

  @override
  Future<void> updateAccount(AppUser user) async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) _authState.value = user;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    _authState.value = null;
  }

  void dispose() => _authState.close();
}
