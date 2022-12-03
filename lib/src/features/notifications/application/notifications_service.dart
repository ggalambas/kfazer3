import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/mutable_notification.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService(ref);
});

class NotificationsService {
  final Ref ref;
  NotificationsService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  NotificationsRepository get notificationsRepository =>
      ref.read(notificationsRepositoryProvider);

  Future<List<Notification>> fetchNotificationList(String? lastId) async {
    final currentUser = authRepository.currentUser!;
    return notificationsRepository.fetchNotificationList(
        currentUser.id, lastId);
  }

  Future<void> markNotificationAsRead(Notification notification) async {
    final currentUser = authRepository.currentUser!;
    final copy = notification.markAsRead();
    await ref
        .read(notificationsRepositoryProvider)
        .setNotification(currentUser.id, copy);
  }

  Future<void> markAllAsRead() async {
    final currentUser = authRepository.currentUser!;
    await notificationsRepository.markAllNotificationsAsRead(currentUser.id);
  }
}

//* Providers

final unreadNotificationCountStreamProvider = StreamProvider.autoDispose<int>(
  (ref) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref
          .watch(notificationsRepositoryProvider)
          .watchUnreadNotificationCount(user.id);
    }
  },
);

final notificationStreamProvider =
    StreamProvider.family.autoDispose<Notification?, String>(
  (ref, notificationId) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref
          .watch(notificationsRepositoryProvider)
          .watchNotification(user.id, notificationId);
    }
  },
);
