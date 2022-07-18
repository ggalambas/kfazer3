import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

//* to use this, run the app with --dart-define=useFakeRepos=true
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  // if (isFake) {
  final repository = FakeAuthRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
  // }
  // return FirebaseAuthRepository();
});

// TODO autodispose?
final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> sendSmsCode(String phoneNumber);
  Future<void> verifySmsCode(String phoneNumber, String smsCode);
  Future<void> createAccount(String phoneNumber, String displayName);
  Future<void> changeUserInfo({String displayName, String phoneNumber});
  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemorStore<AppUser?>(
    // null
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
  Future<void> changeUserInfo({
    String? displayName,
    String? phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) {
      _authState.value = AppUser(
        id: currentUser!.id,
        name: displayName ?? currentUser!.name,
        phoneNumber: phoneNumber ?? currentUser!.phoneNumber,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    // throw Exception();
    _authState.value = null;
  }

  void dispose() => _authState.close();
}
