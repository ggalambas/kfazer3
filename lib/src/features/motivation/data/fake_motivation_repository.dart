import 'package:kfazer3/src/constants/test_motivations.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'motivation_repository.dart';

class FakeMotivationRepository implements MotivationRepository {
  // An InMemoryStore containing the motivation of all groups.
  final _motivations =
      InMemoryStore<Map<GroupId, Motivation>>(kTestMotivations);
  void dispose() => _motivations.close();

  final bool addDelay;
  FakeMotivationRepository({this.addDelay = true});

  @override
  Stream<Motivation> watchMotivation(GroupId groupId) async* {
    await delay(addDelay);
    yield* _motivations.stream.map((motivations) => motivations[groupId] ?? []);
  }

  @override
  Future<void> setMotivation(GroupId groupId, Motivation motivation) async {
    await delay(addDelay);
    // First, get the motivation list
    final motivations = _motivations.value;
    // Then, set the motivation
    motivations[groupId] = motivation;
    // Finally, update the motivation list data (will emit a new value)
    _motivations.value = motivations;
  }
}
