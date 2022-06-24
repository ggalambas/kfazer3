/// The four states that are used to assign tasks to the respective tab of the tasks page.
enum TaskState {
  active,
  pending,
  scheduled,
  archived;

  static List<TaskState> get tabs => values.sublist(0, values.length - 1);
}

mixin TaskStateMixin {
  TaskState get state;

  bool get isActive => state == TaskState.active;
  bool get isPending => state == TaskState.pending;
  bool get isScheduled => state == TaskState.scheduled;
  bool get isArchived => state == TaskState.archived;
}
