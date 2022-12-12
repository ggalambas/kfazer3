import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/motivation/data/quotes_repository.dart';

import '../quote_validators.dart';

final motivationEditControllerProvider =
    StateNotifierProvider.autoDispose<MotivationEditController, AsyncValue>(
  (ref) => MotivationEditController(
    quotesRepository: ref.watch(quotesRepositoryProvider),
  ),
);

class MotivationEditController extends StateNotifier<AsyncValue>
    with QuoteValidators {
  final QuotesRepository quotesRepository;

  MotivationEditController({required this.quotesRepository})
      : super(const AsyncValue.data(null));

  Future<bool> save(GroupId groupId, List<String> quotes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return quotesRepository.setQuotes(groupId, quotes);
    });
    return !state.hasError;
  }
}
