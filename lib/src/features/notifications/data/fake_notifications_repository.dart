import 'package:kfazer3/src/constants/test_notifications.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

class FakeNotificationsRepository extends NotificationsRepository {
  final List<Notification> _notifications = kTestNotifications;

  @override
  Stream<List<Notification>> watchNotificationList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _notifications;
  }
}
