import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/domain/notification_interval.dart';

import 'fake_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  //TODO replace with real repository
  (ref) => FakeNotificationsRepository(),
);

abstract class NotificationsRepository {
  Stream<int> watchUnreadNotificationCount();
  Future<NotificationInterval> fetchNotificationInterval();
  Stream<Notification> watchNotification(String id);
  Future<void> setNotification(Notification notification);
}

//! DB
// delete notifications with more than 2 months

//* Providers

final notificationIntervalFutureProvider =
    FutureProvider.autoDispose<NotificationInterval>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.fetchNotificationInterval();
  },
);

final notificationStreamProvider =
    StreamProvider.family.autoDispose<Notification, String>(
  (ref, id) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotification(id);
  },
  cacheTime: const Duration(minutes: 2),
);

final unreadNotificationCountStreamProvider = StreamProvider.autoDispose<int>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchUnreadNotificationCount();
  },
);
