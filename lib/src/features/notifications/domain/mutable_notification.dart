import 'notification.dart';

/// Helper extension used to mark a notification as read
extension MutableNotification on Notification {
  Notification markAsRead() => _copyWith(read: true);

  Notification _copyWith({
    String? id,
    String? notifierId,
    DateTime? timestamp,
    String? description,
    String? path,
    bool? read,
  }) =>
      Notification(
        id: id ?? this.id,
        notifierId: notifierId ?? this.notifierId,
        timestamp: timestamp ?? this.timestamp,
        description: description ?? this.description,
        path: path ?? this.path,
        read: read ?? this.read,
      );
}
