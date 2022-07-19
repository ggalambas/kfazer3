import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

import 'fake_notifications_repository.dart';

abstract class NotificationsRepository {
  Stream<List<Notification>> watchNotificationList();
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  //TODO replace with real repository
  (ref) => FakeNotificationsRepository(),
);

final notificationListStreamProvider =
    StreamProvider.autoDispose<List<Notification>>(
  (ref) {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    return notificationsRepository.watchNotificationList();
  },
);
