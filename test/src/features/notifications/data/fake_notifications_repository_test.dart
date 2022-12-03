// @Timeout(Duration(milliseconds: 500))

// import 'package:flutter_test/flutter_test.dart';
// import 'package:kfazer3/src/constants/test_notifications.dart';
// import 'package:kfazer3/src/features/notifications/data/fake_notifications_repository.dart';
// import 'package:kfazer3/src/features/notifications/domain/mutable_notification.dart';

// void main() {
//   late FakeNotificationsRepository notificationsRepository;
//   setUp(() {
//     return notificationsRepository =
//         FakeNotificationsRepository(addDelay: false);
//   });
//   tearDown(() => notificationsRepository.dispose());

//   group('FakeNotificationsRepository', () {
//     test('watchUnreadNotificationCount emits unreadNotificationsCount', () {
//       expect(
//         notificationsRepository.watchUnreadNotificationCount(),
//         emits(kTestNotifications.where((n) => !n.read).length),
//       );
//     });
//     test(
//         'fetchNotificationList(null) returns first notificationsPerFetch items',
//         () async {
//       final notifications = kTestNotifications
//         ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
//       expect(
//         await notificationsRepository.fetchNotificationList(null),
//         notifications.take(notificationsRepository.notificationsPerFetch),
//       );
//     });
//     test('fetchNotificationList(15) returns second notificationsPerFetch items',
//         () async {
//       final notifications = kTestNotifications
//         ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
//       expect(
//         await notificationsRepository
//             .fetchNotificationList(notifications[14].id),
//         notifications
//             .skip(15)
//             .take(notificationsRepository.notificationsPerFetch),
//       );
//     });
//     test('fetchNotificationList(-1) returns empty list', () async {
//       expect(
//         await notificationsRepository.fetchNotificationList('-1'),
//         [],
//       );
//     });
//     test('watchNotification(0) emits first item', () {
//       expect(
//         notificationsRepository.watchNotification('0'),
//         emits(kTestNotifications.first),
//       );
//     });
//     test('watchNotification(-1) emits null', () {
//       expect(
//         notificationsRepository.watchNotification('-1'),
//         emits(null),
//       );
//     });
//     test('notification updates', () async {
//       final notification = kTestNotifications.first;
//       final updatedNotification = notification.markAsRead();
//       await notificationsRepository.setNotification(updatedNotification);
//       expect(
//         notificationsRepository.watchNotification(notification.id),
//         emits(updatedNotification),
//       );
//     });
//   });
// }
