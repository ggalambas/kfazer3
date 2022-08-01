import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fake_storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) => FakeStorageRepository(),
);

abstract class StorageRepository {
  Future<String> uploadImage(Uint8List imageBytes, String name);
}
