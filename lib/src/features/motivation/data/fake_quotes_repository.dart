import 'package:kfazer3/src/constants/test_motivations.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'quotes_repository.dart';

class FakeQuotesRepository implements QuotesRepository {
  // An InMemoryStore containing the quotes of each group.
  final _quotes = InMemoryStore<Map<GroupId, List<String>>>(kTestQuotes);
  void dispose() => _quotes.close();

  final bool addDelay;
  FakeQuotesRepository({this.addDelay = true});

  @override
  Stream<List<String>?> watchQuotes(GroupId groupId) async* {
    await delay(addDelay);
    yield* _quotes.stream.map((quotes) => quotes[groupId]);
  }

  @override
  Future<void> setQuotes(GroupId groupId, List<String> quotes) async {
    await delay(addDelay);
    // First, get the quote list
    final copy = _quotes.value;
    // Then, set the new quotes
    copy[groupId] = quotes;
    // Finally, update the quote list data (will emit a new value)
    _quotes.value = copy;
  }
}
