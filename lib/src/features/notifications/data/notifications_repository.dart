import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

import 'fake_notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) {
    final repository =
        FakeNotificationsRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class NotificationsRepository {
  int get notificationsPerFetch;
  Stream<int> watchUnreadNotificationCount(String userId);
  Future<List<Notification>> fetchNotificationList(
      String userId, String? lastId);
  Stream<Notification?> watchNotification(String userId, String id);
  Future<void> setNotification(String userId, Notification notification);
  Future<void> markAllNotificationsAsRead(String userId);
}

//! DB
// delete notifications with more than 2 months