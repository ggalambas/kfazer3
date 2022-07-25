import 'package:kfazer3/src/constants/test_notifications.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/domain/notification_interval.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeNotificationsRepository extends NotificationsRepository {
  final _notifications = InMemorStore<List<Notification>>(kTestNotifications);

  @override
  Stream<int> watchUnreadNotificationCount() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield* _notifications.stream.map((ns) => ns.where((n) => !n.read).length);
  }

  @override
  Future<NotificationInterval> fetchNotificationInterval() async {
    await Future.delayed(const Duration(seconds: 1));
    final notifications = _notifications.value
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return NotificationInterval.fromString(
      notifications.last.id,
      notifications.first.id,
    );
  }

  @override
  Stream<Notification> watchNotification(String id) async* {
    await Future.delayed(const Duration(seconds: 1));
    yield* _notifications.stream.map((ns) => ns.firstWhere((n) => n.id == id));
  }

  @override
  Future<void> setNotification(Notification notification) async {
    await Future.delayed(const Duration(seconds: 1));
    // First, get the notification list
    final notifications = _notifications.value;
    // Then, change the notification
    final i = notifications.indexWhere((n) => notification.id == n.id);
    notifications[i] = notification;
    // Finally, update the notification list data (will emit a new value)
    _notifications.value = notifications;
  }
}
