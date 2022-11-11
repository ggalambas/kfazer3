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

  Future<void> uploadPictureAndSaveUser(AppUser user, Uint8List bytes) async {
    final photoUrl =
        await accountStorageRepository.uploadProfilePicture(user.id, bytes);
    final updatedUser = user.updatePhotoUrl(photoUrl);
    authRepository.updateUser(updatedUser);
  }

  Future<void> removePictureAndSaveUser(AppUser user) async {
    await accountStorageRepository.removeProfilePicture(user.id);
    final updatedUser = user.updatePhotoUrl(null);
    authRepository.updateUser(updatedUser);
  }
}
