import 'package:kfazer3/src/features/auth/domain/app_user.dart';

import 'auth_repository.dart';

// TODO implement FirebaseAuthRepository
class FirebaseAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() {
    throw UnimplementedError();
  }

  @override
  AppUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> signInWithPhoneNumber(String phoneNumber) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyPhoneNumber(String smsCode) {
    throw UnimplementedError();
  }
}
