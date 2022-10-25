import 'package:flutter/material.dart';

/// The four states that are used to assign tasks to the respective tab of the tasks page.
enum TaskState {
  ongoing(Icons.pending_actions),
  delegated(Icons.double_arrow),
  scheduled(Icons.event),
  completed(Icons.check_circle);

  final IconData icon;
  const TaskState(this.icon);

  static List<TaskState> get tabs => values.sublist(0, values.length - 1);
}

mixin TaskStateMixin {
  TaskState get state;

  bool get isOngoing => state == TaskState.ongoing;
  bool get isDelegated => state == TaskState.delegated;
  bool get isScheduled => state == TaskState.scheduled;
  bool get isCompleted => state == TaskState.completed;
}
