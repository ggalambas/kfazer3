// @Timeout(Duration(milliseconds: 500))

// import 'package:flutter_test/flutter_test.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:kfazer3/src/constants/test_notifications.dart';
// import 'package:kfazer3/src/features/auth/domain/app_user.dart';
// import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
// import 'package:kfazer3/src/features/notifications/presentation/notification_paging_controller.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../../mocks.dart';

// void main() {
//   const itemCount = 10;
//   late MockNotificationsRepository notificationsRepository;
//   late NotificationPagingController controller;
//   setUp(() {
//     final testPhoneNumber = PhoneNumber('+351', '912345678');
//     const testName = 'Jimmy Hawkins';
//     final testUser = AppUser(
//       id: testPhoneNumber.full,
//       phoneNumber: testPhoneNumber,
//       name: testName,
//     );
//     notificationsRepository = MockNotificationsRepository();
//     controller = NotificationPagingController(
//       notificationsRepository: notificationsRepository,
//       getUserFrom: (_) async => testUser,
//     );
//     when(() => notificationsRepository.notificationsPerFetch)
//         .thenReturn(itemCount);
//   });
//   group('NotificationPagingController', () {
//     test('initial state', () {
//       expect(controller.value.status, PagingStatus.loadingFirstPage);
//       expect(controller.nextPageKey, 0);
//       expect(controller.itemList, null);
//       expect(controller.error, null);
//     });
//     test('notificationsPerFetch', () async {
//       expect(controller.notificationsPerFetch, itemCount);
//       verify(() => notificationsRepository.notificationsPerFetch).called(1);
//     });
//     group('fetchItems first page', () {
//       test('first page finds no items', () async {
//         // setup
//         when(() => notificationsRepository.fetchNotificationList(null))
//             .thenAnswer((_) async => []);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.noItemsFound);
//         expect(controller.nextPageKey, null);
//         expect(controller.itemList, []);
//         expect(controller.error, null);
//         verify(() => notificationsRepository.fetchNotificationList(null))
//             .called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(1);
//       });
//       test('first page completes', () async {
//         // setup
//         final notifications = kTestNotifications.take(itemCount - 1).toList();
//         when(() => notificationsRepository.fetchNotificationList(null))
//             .thenAnswer((_) async => notifications);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.completed);
//         expect(controller.nextPageKey, null);
//         expect(controller.itemList, notifications);
//         expect(controller.error, null);
//         verify(() => notificationsRepository.fetchNotificationList(null))
//             .called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(1);
//       });
//       test('first page stays ongoing', () async {
//         // setup
//         final notifications = kTestNotifications.take(itemCount).toList();
//         when(() => notificationsRepository.fetchNotificationList(null))
//             .thenAnswer((_) async => notifications);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.ongoing);
//         expect(controller.nextPageKey, controller.firstPageKey + 1);
//         expect(controller.itemList, notifications);
//         expect(controller.error, null);
//         verify(() => notificationsRepository.fetchNotificationList(null))
//             .called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(1);
//       });
//       test('first page fails', () async {
//         // setup
//         final exception = Exception('Connection failed');
//         when(() => notificationsRepository.fetchNotificationList(null))
//             .thenThrow(exception);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.firstPageError);
//         expect(controller.nextPageKey, 0);
//         expect(controller.itemList, null);
//         expect(controller.error, isNotNull);
//         verify(() => notificationsRepository.fetchNotificationList(null))
//             .called(1);
//         verifyNever(() => notificationsRepository.notificationsPerFetch);
//       });
//     });
//     group('fetchItems next page', () {
//       final firstNotifications = kTestNotifications.take(itemCount).toList();
//       setUp(() async {
//         when(() => notificationsRepository.fetchNotificationList(null))
//             .thenAnswer((_) async => firstNotifications);
//         await controller.fetchItems(controller.nextPageKey!);
//       });
//       test('next page finds no items', () async {
//         // setup
//         when(() => notificationsRepository.fetchNotificationList(
//             firstNotifications.last.id)).thenAnswer((_) async => []);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.completed);
//         expect(controller.nextPageKey, null);
//         expect(controller.itemList, firstNotifications);
//         expect(controller.error, null);
//         verify(() => notificationsRepository
//             .fetchNotificationList(firstNotifications.last.id)).called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(2);
//       });
//       test('next page completes', () async {
//         // setup
//         final notifications =
//             kTestNotifications.skip(itemCount).take(itemCount - 1).toList();
//         when(() => notificationsRepository.fetchNotificationList(
//             firstNotifications.last.id)).thenAnswer((_) async => notifications);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.completed);
//         expect(controller.nextPageKey, null);
//         expect(controller.itemList, [...firstNotifications, ...notifications]);
//         expect(controller.error, null);
//         verify(() => notificationsRepository
//             .fetchNotificationList(firstNotifications.last.id)).called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(2);
//       });
//       test('next page stays ongoing', () async {
//         // setup
//         final notifications =
//             kTestNotifications.skip(itemCount).take(itemCount).toList();
//         when(() => notificationsRepository.fetchNotificationList(
//             firstNotifications.last.id)).thenAnswer((_) async => notifications);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.ongoing);
//         expect(controller.nextPageKey, controller.firstPageKey + 2);
//         expect(controller.itemList, [...firstNotifications, ...notifications]);
//         expect(controller.error, null);
//         verify(() => notificationsRepository
//             .fetchNotificationList(firstNotifications.last.id)).called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(2);
//       });
//       test('next page fails', () async {
//         // setup
//         final exception = Exception('Connection failed');
//         when(() => notificationsRepository.fetchNotificationList(
//             firstNotifications.last.id)).thenThrow(exception);
//         // run
//         await controller.fetchItems(controller.nextPageKey!);
//         // verify
//         expect(controller.value.status, PagingStatus.subsequentPageError);
//         expect(controller.nextPageKey, 1);
//         expect(controller.itemList, firstNotifications);
//         expect(controller.error, isNotNull);
//         verify(() => notificationsRepository
//             .fetchNotificationList(firstNotifications.last.id)).called(1);
//         verify(() => notificationsRepository.notificationsPerFetch).called(1);
//       });
//     });
//   });
// }
