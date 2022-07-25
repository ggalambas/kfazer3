import 'notification.dart';

/// Helper extension used to mark a notification as read
extension ReadableNotification on Notification {
  Notification markAsRead() => Notification(
        id: id,
        notifierId: notifierId,
        timestamp: timestamp,
        description: description,
        path: path,
        read: true,
      );
}
