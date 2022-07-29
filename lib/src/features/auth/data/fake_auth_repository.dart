import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(
    // null,
    AppUser(
      id: '+351912776411'.split('').reversed.join(),
      name: 'Alexandre Galambas',
      phoneNumber: PhoneNumber('+351', '912776411'),
    ),
  );

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;
  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> sendSmsCode(PhoneNumber phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    if (currentUser == null) {
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> verifySmsCode(PhoneNumber phoneNumber, String smsCode) async {
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
  Future<void> createAccount(
    PhoneNumber phoneNumber,
    String displayName,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    if (currentUser == null) {
      await _signInWithPhoneNumber(phoneNumber, displayName: displayName);
    } else {
      throw Exception();
    }
  }

  Future<void> _signInWithPhoneNumber(
    PhoneNumber phoneNumber, {
    String? displayName,
  }) async {
    if (currentUser == null) {
      _authState.value = AppUser(
        id: phoneNumber
            .toString()
            .replaceAll(' ', '')
            .split('')
            .reversed
            .join(),
        name: displayName ?? 'Alexandre Galambas',
        phoneNumber: phoneNumber,
      );
    }
  }

  @override
  Future<void> updateAccount(AppUser user) async {
    // await Future.delayed(const Duration(seconds: 1));
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
