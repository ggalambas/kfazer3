import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';

import 'fake_motivation_repository.dart';

final motivationRepositoryProvider = Provider<MotivationRepository>(
  (ref) {
    final repository = FakeMotivationRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class MotivationRepository {
  Stream<Motivation> watchMotivation(GroupId groupId);
  Future<void> setMotivation(GroupId groupId, Motivation motivation);
}

//* Providers

final motivationStreamProvider =
    StreamProvider.autoDispose.family<Motivation, GroupId>(
  (ref, groupId) {
    final repository = ref.watch(motivationRepositoryProvider);
    return repository.watchMotivation(groupId);
  },
);
