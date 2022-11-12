import 'dart:math';
import 'dart:typed_data';

import 'package:kfazer3/src/utils/delay.dart';

import 'group_storage_repository.dart';

class FakeGroupStorageRepository implements GroupStorageRepository {
  final bool addDelay;
  FakeGroupStorageRepository({this.addDelay = true});

  @override
  Future<void> removeGroupPicture(String groupId) async {
    await delay(addDelay);
  }

  // https://avatars.dicebear.com/styles
  @override
  Future<String> uploadGroupPicture(
    String groupId,
    Uint8List imageBytes,
  ) async {
    await delay(addDelay);
    final rnd = Random();
    final imageName =
        String.fromCharCodes(Iterable.generate(10, (_) => rnd.nextInt(10)));
    return 'https://avatars.dicebear.com/api/gridy/$imageName.png';
  }
}
