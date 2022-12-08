import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/motivation/data/motivation_repository.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';

import 'motivation_validators.dart';

typedef MessageControllers = List<TextEditingController>;
typedef MotivationCallback = Future<Motivation> Function();

extension MotivationalMessageControllers on Motivation {
  MessageControllers get controllers => map(
        (message) => TextEditingController(text: message),
      ).toList();
}

final motivationFormControllerProvider = StateNotifierProvider.family
    .autoDispose<MotivationFormController, AsyncValue<MessageControllers>,
        String>(
  (ref, groupId) {
    return MotivationFormController(
      motivation: ref.read(motivationStreamProvider(groupId)).valueOrNull!,
      fetchMotivation: () => ref.read(motivationStreamProvider(groupId).future),
    );
  },
);

class MotivationFormController
    extends StateNotifier<AsyncValue<MessageControllers>>
    with MotivationValidators {
  //
  MotivationFormController({
    Motivation? motivation,
    MotivationCallback? fetchMotivation,
  }) : super(initialValue(motivation));

  static AsyncValue<MessageControllers> initialValue(Motivation? motivation) {
    return motivation == null
        ? const AsyncValue.loading()
        : AsyncValue.data(motivation.controllers);
  }

  void init(MotivationCallback fetchMotivation) async {
    state = await AsyncValue.guard(() async {
      final motivation = await fetchMotivation();
      return motivation.controllers;
    });
  }

  MessageControllers get _controllers => state.value!;
  List<String> get motivation => _controllers.map((c) => c.text).toList();

  void addMessage() {
    final copy = MessageControllers.from(_controllers);
    copy.insert(0, TextEditingController());
    state = AsyncValue.data(copy);
  }

  void removeMessage(int i) {
    final copy = MessageControllers.from(_controllers);
    final controller = copy.removeAt(i);
    controller.dispose();
    state = AsyncValue.data(copy);
  }

  void clearAllMessages() {
    final copy = MessageControllers.from(_controllers);
    state = const AsyncValue.data([]);
    for (final controller in copy) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
