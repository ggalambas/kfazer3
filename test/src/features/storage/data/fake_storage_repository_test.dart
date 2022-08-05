import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/storage/data/fake_storage_repository.dart';

void main() {
  FakeStorageRepository makeStorageRepository() =>
      FakeStorageRepository(addDelay: false);

  group('FakeStorageRepository', () {
    test('uploadImage returns link', () async {
      final storageRepository = makeStorageRepository();
      expect(
        await storageRepository.uploadImage(Uint8List(0), ''),
        matches('http'),
      );
    });
  });
}
