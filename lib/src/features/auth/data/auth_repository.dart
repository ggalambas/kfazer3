import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/utils/stream_notifier.dart';

import 'fake_auth_repository.dart';

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

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> sendSmsCode(String phoneNumber);
  Future<void> verifySmsCode(String phoneNumber, String smsCode);
  Future<void> createAccount(String phoneNumber, String displayName);
  Future<void> updateAccount(AppUser user);
  Future<void> signOut();
}

//* Providers

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUserStateProvider =
    StateNotifierProvider.autoDispose<StreamNotifier<AppUser>, AppUser>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return StreamNotifier(
      initial: repository.currentUser!,
      stream: repository
          .authStateChanges()
          .where((user) => user != null)
          .cast<AppUser>(),
    );
  },
);
