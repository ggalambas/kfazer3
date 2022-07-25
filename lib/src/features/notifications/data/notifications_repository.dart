import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

import 'fake_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  //TODO replace with real repository
  (ref) => FakeNotificationsRepository(),
);

abstract class NotificationsRepository {
  Stream<int> watchUnreadNotificationCount();
  Stream<List<Notification>> watchNotificationList(String? lastNotificationId);
  Future<void> setNotification(Notification notification);
}

//! DB
// delete notifications with more than 2 months

//* Providers

final notificationListStreamProvider =
    StreamProvider.family.autoDispose<List<Notification>, String?>(
  (ref, lastNotificationId) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotificationList(lastNotificationId);
  },
  cacheTime: const Duration(minutes: 2),
);

final unreadNotificationCountStreamProvider = StreamProvider.autoDispose<int>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchUnreadNotificationCount();
  },
);
