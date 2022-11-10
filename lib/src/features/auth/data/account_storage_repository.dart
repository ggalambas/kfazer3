import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';

import 'fake_account_storage_repository.dart';

final accountStorageRepositoryProvider = Provider<AccountStorageRepository>(
  (ref) => FakeAccountStorageRepository(addDelay: addRepositoryDelay),
);

abstract class AccountStorageRepository {
  Future<String> uploadProfilePicture(String userId, Uint8List imageBytes);
  Future<void> removeProfilePicture(String userId);
}
