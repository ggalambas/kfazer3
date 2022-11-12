import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';

import 'fake_group_storage_repository.dart';

final groupStorageRepositoryProvider = Provider<GroupStorageRepository>(
  (ref) => FakeGroupStorageRepository(addDelay: addRepositoryDelay),
);

abstract class GroupStorageRepository {
  Future<String> uploadGroupPicture(String groupId, Uint8List imageBytes);
  Future<void> removeGroupPicture(String groupId);
}
