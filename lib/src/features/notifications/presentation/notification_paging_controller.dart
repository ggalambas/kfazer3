import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/team/data/users_repository.dart';

final notificationPagingControllerProvider =
    Provider.autoDispose<NotificationPagingController>(
  (ref) {
    final controller = NotificationPagingController(ref);
    ref.onDispose(() => controller.dispose());
    return controller;
  },
);

class NotificationPagingController extends PagingController<int, Notification> {
  final ProviderRef _ref;

  NotificationPagingController(this._ref) : super(firstPageKey: 0) {
    addPageRequestListener(_fetchItems);
    _ref.onDispose(dispose);
  }

  int get notificationsPerFetch =>
      _ref.read(notificationsRepositoryProvider).notificationsPerFetch;

  Future<void> _fetchItems(int pageKey) async {
    try {
      // get last notification from the currently displaying list
      final currentNotificationList = itemList ?? [];
      final lastNotification =
          currentNotificationList.isEmpty ? null : currentNotificationList.last;

      // load next notifications
      final nextNotificationList = await _ref
          .read(notificationsRepositoryProvider)
          .fetchNotificationList((lastNotification?.id));

      // pre load users
      await Future.wait(
        nextNotificationList.map((notification) =>
            _ref.read(userStreamProvider(notification.notifierId).future)),
      );

      // append notifications
      final noMoreItems = nextNotificationList.length < notificationsPerFetch;
      noMoreItems
          ? appendLastPage(nextNotificationList)
          : appendPage(nextNotificationList, ++pageKey);
    } catch (e) {
      error = e;
    }
  }
}
