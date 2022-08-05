import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_notifications.dart';
import 'package:kfazer3/src/features/notifications/data/fake_notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/readable_notification.dart';

void main() {
  FakeNotificationsRepository makeNotificationsRepository() =>
      FakeNotificationsRepository(addDelay: false);

  group('FakeNotificationsRepository', () {
    test('watchUnreadNotificationCount emits unreadNotificationsCount', () {
      final notificationsRepository = makeNotificationsRepository();
      expect(
        notificationsRepository.watchUnreadNotificationCount(),
        emits(kTestNotifications.where((n) => !n.read).length),
      );
    });
    test(
      'fetchNotificationList(null) returns first notificationsPerFetch items',
      () async {
        final notificationsRepository = makeNotificationsRepository();
        final notifications = kTestNotifications
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        expect(
          await notificationsRepository.fetchNotificationList(null),
          notifications.take(notificationsRepository.notificationsPerFetch),
        );
      },
    );
    test(
      'fetchNotificationList(15) returns second notificationsPerFetch items',
      () async {
        final notificationsRepository = makeNotificationsRepository();
        final notifications = kTestNotifications
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        expect(
          await notificationsRepository
              .fetchNotificationList(notifications[14].id),
          notifications
              .skip(15)
              .take(notificationsRepository.notificationsPerFetch),
        );
      },
    );
    test('fetchNotificationList(-1) returns empty list', () async {
      final notificationsRepository = makeNotificationsRepository();
      expect(
        await notificationsRepository.fetchNotificationList('-1'),
        [],
      );
    });
    test('watchNotification(0) emits first item', () {
      final notificationsRepository = makeNotificationsRepository();
      expect(
        notificationsRepository.watchNotification('0'),
        emits(kTestNotifications.first),
      );
    });
    test('watchNotification(-1) emits null', () {
      final notificationsRepository = makeNotificationsRepository();
      expect(
        notificationsRepository.watchNotification('-1'),
        emits(null),
      );
    });
    test('notification updates', () async {
      final notificationsRepository = makeNotificationsRepository();
      final notification = kTestNotifications.first;
      final updatedNotification = notification.markAsRead();
      await notificationsRepository.setNotification(updatedNotification);
      expect(
        notificationsRepository.watchNotification(notification.id),
        emits(updatedNotification),
      );
    });
    test('setNotification after dispose throws exception', () async {
      final notificationsRepository = makeNotificationsRepository();
      notificationsRepository.dispose();
      expect(
        notificationsRepository.setNotification(kTestNotifications.first),
        throwsStateError,
      );
    });
  });
}
