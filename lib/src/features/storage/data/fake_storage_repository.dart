import 'dart:typed_data';

import 'package:kfazer3/src/utils/delay.dart';

import 'storage_repository.dart';

class FakeStorageRepository implements StorageRepository {
  final bool addDelay;
  FakeStorageRepository({this.addDelay = true});

  @override
  Future<String> uploadImage(Uint8List imageBytes, String name) async {
    await delay(addDelay);
    return 'https://i.pravatar.cc/';
  }
}
