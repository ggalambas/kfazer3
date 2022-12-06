import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'motivation_validators.dart';

typedef MessageControllers = List<TextEditingController>;
typedef GroupCallback = Future<Group?> Function();

extension GroupMessageControllers on Group {
  MessageControllers get messageControllers => motivationalMessages
      .map((message) => TextEditingController(text: message))
      .toList();
}

final motivationalMessagesControllerProvider = StateNotifierProvider.family
    .autoDispose<MotivationalMessagesController,
        AsyncValue<MessageControllers?>, String>(
  (ref, groupId) => MotivationalMessagesController(
    group: ref.read(groupStreamProvider(groupId)).valueOrNull,
    fetchGroup: () => ref.read(groupStreamProvider(groupId).future),
  ),
);

class MotivationalMessagesController
    extends StateNotifier<AsyncValue<MessageControllers?>>
    with MotivationValidators {
  //
  MotivationalMessagesController({
    Group? group,
    required GroupCallback fetchGroup,
  }) : super(initialValue(group)) {
    if (group == null) init(fetchGroup);
  }

  static AsyncValue<MessageControllers?> initialValue(Group? group) {
    return group == null
        ? const AsyncValue.loading()
        : AsyncValue.data(group.messageControllers);
  }

  void init(GroupCallback fetchGroup) async {
    state = await AsyncValue.guard(() async {
      final group = await fetchGroup();
      return group?.messageControllers;
    });
  }

  MessageControllers get _controllers => state.value!;
  List<String> get messages => _controllers.map((c) => c.text).toList();

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
