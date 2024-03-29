import 'dart:math';
import 'dart:typed_data';

import 'package:kfazer3/src/utils/delay.dart';

import 'account_storage_repository.dart';

class FakeAccountStorageRepository implements AccountStorageRepository {
  final bool addDelay;
  FakeAccountStorageRepository({this.addDelay = true});

  @override
  Future<void> removeProfilePicture(String userId) async {
    await delay(addDelay);
  }

  // https://avatars.dicebear.com/styles
  @override
  Future<String> uploadProfilePicture(
    String userId,
    Uint8List imageBytes,
  ) async {
    await delay(addDelay);
    final rnd = Random();
    final imageName =
        String.fromCharCodes(Iterable.generate(10, (_) => rnd.nextInt(10)));
    return 'https://avatars.dicebear.com/api/micah/$imageName.png';
  }
}
