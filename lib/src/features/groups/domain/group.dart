import 'package:equatable/equatable.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';

import 'group_plan.dart';

// TODO move default motivational messages to another file
// TODO member list

/// * The group identifier is an important concept and can have its own type.
typedef GroupId = String;

/// Class representing a group.
class Group with EquatableMixin {
  /// Unique group id
  final GroupId id;
  final String title;
  final String? description;
  final String? photoUrl;
  final List<String> motivationalMessages;

  final GroupPlan plan;

  const Group({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    this.motivationalMessages = kMotivationalMessages, //?
    required this.plan,
  });

  @override
  String toString() {
    return 'Group(id: $id, title: $title, description: $description, photoUrl: $photoUrl, motivationalMessages: $motivationalMessages, plan: $plan)';
  }

  @override
  List<Object?> get props => [id];
}
