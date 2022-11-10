import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/account_storage_repository.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/mutable_app_user.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(ref);
});

class AccountService {
  final Ref ref;
  AccountService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  AccountStorageRepository get accountStorageRepository =>
      ref.read(accountStorageRepositoryProvider);

  Future<void> updateAccount(AppUser user, Uint8List? imageBytes) async {
    final photoUrl = await accountStorageRepository.uploadProfilePicture(
        user.id, imageBytes!);
    final updatedUser = user.updatePhotoUrl(photoUrl);
    authRepository.updateUser(updatedUser);
  }
}
