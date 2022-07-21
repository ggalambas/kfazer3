import 'package:flutter_riverpod/flutter_riverpod.dart';

final motivationalMessagesControllerProvider = StateNotifierProvider
    .autoDispose<MotivationalMessagesController, AsyncValue>(
  (ref) => MotivationalMessagesController(),
);

class MotivationalMessagesController extends StateNotifier<AsyncValue> {
  MotivationalMessagesController() : super(const AsyncValue.data(false));

  void edit() => state = const AsyncValue.data(true);
  void cancel() => state = const AsyncValue.data(false);

  void clear() {}

  Future<bool> save() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        //TODO save messages
        return false;
      },
    );
    return !state.hasError;
  }
}
