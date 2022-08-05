import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_notifications.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeNotificationsRepository implements NotificationsRepository {
  // final _notifications = InMemoryStore<List<Notification>>([]);
  final _notifications = InMemoryStore<List<Notification>>(kTestNotifications);
  void dispose() => _notifications.close();

  final bool addDelay;
  FakeNotificationsRepository({this.addDelay = true});

  @override
  final notificationsPerFetch = 15;

  @override
  Stream<int> watchUnreadNotificationCount() async* {
    await delay(addDelay);
    yield* _notifications.stream.map((ns) => ns.where((n) => !n.read).length);
  }

  @override
  Future<List<Notification>> fetchNotificationList(String? lastId) async {
    await delay(addDelay);
    var notifications = _notifications.value
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (lastId != null) {
      notifications =
          notifications.skipWhile((n) => n.id != lastId).skip(1).toList();
    }
    return notifications.take(notificationsPerFetch).toList();
  }

  @override
  Stream<Notification?> watchNotification(String id) async* {
    yield* _notifications.stream
        .map((ns) => ns.firstWhereOrNull((n) => n.id == id));
  }

  @override
  Future<void> setNotification(Notification notification) async {
    await delay(addDelay);
    // First, get the notification list
    final notifications = _notifications.value;
    // Then, change the notification
    final i = notifications.indexWhere((n) => notification.id == n.id);
    notifications[i] = notification;
    // Finally, update the notification list data (will emit a new value)
    _notifications.value = notifications;
  }
}
