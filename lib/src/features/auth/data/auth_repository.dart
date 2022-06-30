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

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInWithPhoneNumber(String phoneNumber);
  Future<void> verifyPhoneNumber(String smsCode);
  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemorStore<AppUser?>(null);
  String? phoneNumber;

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;
  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    if (currentUser == null) this.phoneNumber = phoneNumber;
  }

  @override
  Future<void> verifyPhoneNumber(String smsCode) async {
    if (currentUser == null && phoneNumber != null) {
      _authState.value = AppUser(
        id: phoneNumber!.split('').reversed.join(),
        name: 'Tareco Buíto',
        phoneNumber: phoneNumber!,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception();
    _authState.value = null;
  }

  void dispose() => _authState.close();
}
