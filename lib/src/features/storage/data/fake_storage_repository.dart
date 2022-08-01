import 'dart:typed_data';

import 'storage_repository.dart';

class FakeStorageRepository implements StorageRepository {
  @override
  Future<String> uploadImage(Uint8List imageBytes, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'https://i.pravatar.cc/';
  }
}
