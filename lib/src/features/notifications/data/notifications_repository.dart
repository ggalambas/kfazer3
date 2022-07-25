import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

import 'fake_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  //TODO replace with real repository
  (ref) => FakeNotificationsRepository(),
);

abstract class NotificationsRepository {
  Stream<List<Notification>> watchNotificationList();
  Future<void> setNotification(Notification notification);
  Stream<int> watchNotificationCount();
}

//* Providers

final notificationListStreamProvider =
    StreamProvider.autoDispose<List<Notification>>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotificationList();
  },
);

final notificationCountStreamProvider = StreamProvider.autoDispose<int>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotificationCount();
  },
);
