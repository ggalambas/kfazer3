import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/test_motivations.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_validators.dart';

//TODO this is duplicated
//* delete and import the other
//* OR
//* move it to another file
typedef MessageControllers = List<TextEditingController>;

//TODO delete the group extension and use this one? Think about a better one?
extension ControllersList on List<String> {
  MessageControllers get asControllers =>
      map((message) => TextEditingController(text: message)).toList();
}

final initialMessagesControllerProvider = StateNotifierProvider.autoDispose<
    InitialMessagesController, MessageControllers>(
  (ref) => InitialMessagesController(),
);

class InitialMessagesController extends StateNotifier<MessageControllers>
    with MotivationValidators {
  //
  //TODO change how we get the initial messages
  InitialMessagesController() : super(kMotivation.asControllers);

  List<String> get messages => state.map((c) => c.text).toList();

  void addMessage() {
    final copy = MessageControllers.from(state);
    copy.insert(0, TextEditingController());
    state = copy;
  }

  void removeMessage(int i) {
    final copy = MessageControllers.from(state);
    final controller = copy.removeAt(i);
    controller.dispose();
    state = copy;
  }

  void clearAllMessages() {
    final copy = MessageControllers.from(state);
    state = [];
    for (final controller in copy) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    for (final controller in state) {
      controller.dispose();
    }
    super.dispose();
  }
}
