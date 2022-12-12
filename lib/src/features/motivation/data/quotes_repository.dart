import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'fake_quotes_repository.dart';

final quotesRepositoryProvider = Provider<QuotesRepository>(
  (ref) {
    final repository = FakeQuotesRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class QuotesRepository {
  Stream<List<String>?> watchQuotes(GroupId groupId);
  Future<void> setQuotes(GroupId groupId, List<String> quotes);
}

//* Providers

final quotesStreamProvider =
    StreamProvider.autoDispose.family<List<String>?, GroupId>(
  (ref, groupId) {
    final repository = ref.watch(quotesRepositoryProvider);
    return repository.watchQuotes(groupId);
  },
);
