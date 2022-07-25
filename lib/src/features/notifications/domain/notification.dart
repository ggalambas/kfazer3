import 'package:equatable/equatable.dart';

/// Class representing a notifications.
class Notification with EquatableMixin {
  /// Unique notification id
  final String id;

  /// Notification sender user id
  final String notifierId;

  final DateTime timestamp;
  final String description;
  final String path;
  final bool read;

  Notification({
    required this.id,
    required this.notifierId,
    required this.timestamp,
    required this.description,
    required this.path,
    required this.read,
  });

  @override
  List<Object?> get props => [id];
}
