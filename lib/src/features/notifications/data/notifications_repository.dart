import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

import 'fake_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) {
    final repository = FakeNotificationsRepository();
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class NotificationsRepository {
  int get notificationsPerFetch;
  Stream<int> watchUnreadNotificationCount();
  Future<List<Notification>> fetchNotificationList(String? lastId);
  Stream<Notification> watchNotification(String id);
  Future<void> setNotification(Notification notification);
}

//! DB
// delete notifications with more than 2 months

//* Providers

final unreadNotificationCountStreamProvider = StreamProvider.autoDispose<int>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchUnreadNotificationCount();
  },
);

final notificationStreamProvider =
    StreamProvider.family.autoDispose<Notification, String>(
  (ref, id) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotification(id);
  },
);
