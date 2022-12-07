import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/notifications/application/notifications_service.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';

final notificationPagingControllerProvider =
    Provider.autoDispose<NotificationPagingController>(
  (ref) {
    final controller = NotificationPagingController(
      notificationsRepository: ref.watch(notificationsRepositoryProvider),
      notificationsService: ref.watch(notificationsServiceProvider),
      getUserFrom: (userId) => ref.read(userStreamProvider(userId).future),
    );
    ref.onDispose(controller.dispose);
    return controller;
  },
);

class NotificationPagingController extends PagingController<int, Notification> {
  final NotificationsRepository notificationsRepository;
  final NotificationsService notificationsService;
  final Future<AppUser?> Function(String userId) getUserFrom;

  NotificationPagingController({
    required this.notificationsRepository,
    required this.notificationsService,
    required this.getUserFrom,
  }) : super(firstPageKey: 0) {
    addPageRequestListener(fetchItems);
  }

  int get notificationsPerFetch =>
      notificationsRepository.notificationsPerFetch;

  Future<void> fetchItems(int pageKey) async {
    try {
      // get last notification from the currently displaying list
      final currentNotificationList = itemList ?? [];
      final lastNotification =
          currentNotificationList.isEmpty ? null : currentNotificationList.last;

      // load next notifications
      final nextNotificationList = await notificationsService
          .fetchNotificationList(lastNotification?.id);

      // pre load users
      await Future.wait(nextNotificationList
          .map((notification) => getUserFrom(notification.notifierId)));

      // append notifications
      final noMoreItems = nextNotificationList.length < notificationsPerFetch;
      noMoreItems
          ? appendLastPage(nextNotificationList)
          : appendPage(nextNotificationList, ++pageKey);
    } catch (e) {
      if (!disposed) error = e;
    }
  }

  bool disposed = false;
  @override
  void dispose() async {
    disposed = true;
    super.dispose();
  }
}
