import 'package:kfazer3/src/constants/test_notifications.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeNotificationsRepository extends NotificationsRepository {
  final _notifications = InMemorStore<List<Notification>>(kTestNotifications);

  @override
  Stream<List<Notification>> watchNotificationList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield* _notifications.stream.map(
      (ns) => ns..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
    );
  }

  @override
  Stream<int> watchNotificationCount() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield* _notifications.stream.map((ns) => ns.where((n) => !n.read).length);
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
