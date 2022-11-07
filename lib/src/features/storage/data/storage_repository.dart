import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';

import 'fake_storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) => FakeStorageRepository(addDelay: addRepositoryDelay),
);

abstract class StorageRepository {
  Future<String> uploadImage(Uint8List imageBytes, String name);
}
