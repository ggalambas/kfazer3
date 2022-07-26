import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

final notificationPagingControllerProvider =
    Provider.autoDispose<NotificationPagingController>(
  (ref) => NotificationPagingController(ref),
);

class NotificationPagingController extends PagingController<int, Notification> {
  final ProviderRef ref;

  NotificationPagingController(this.ref) : super(firstPageKey: 0) {
    addPageRequestListener(_fetchItems);
    ref.onDispose(dispose);
  }

  int get notificationsPerFetch =>
      ref.read(notificationsRepositoryProvider).notificationsPerFetch;

  Future<void> _fetchItems(int pageKey) async {
    try {
      final currentNotificationList = itemList ?? [];
      final lastNotification =
          currentNotificationList.isEmpty ? null : currentNotificationList.last;

      final newNotificationList = await ref
          .read(notificationsRepositoryProvider)
          .fetchNotificationList((lastNotification?.id));

      final noMoreItems = newNotificationList.length < notificationsPerFetch;
      noMoreItems
          ? appendLastPage(newNotificationList)
          : appendPage(newNotificationList, ++pageKey);
    } catch (e) {
      error = e;
    }
  }
}
