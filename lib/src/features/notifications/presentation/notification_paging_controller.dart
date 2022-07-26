import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/team/data/users_repository.dart';

final isNotificationPagingLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) =>
      ref.watch(notificationPagingControllerProvider).value.status ==
      PagingStatus.loadingFirstPage,
);

final notificationPagingControllerProvider =
    Provider.autoDispose<NotificationPagingController>(
  (ref) => NotificationPagingController(ref),
);

class NotificationPagingController extends PagingController<int, Notification> {
  final ProviderRef ref;

  NotificationPagingController(this.ref) : super(firstPageKey: 0) {
    addPageRequestListener(_fetchItems);
    addStatusListener((status) {
      ref.read(isNotificationPagingLoadingProvider.state).state =
          status == PagingStatus.loadingFirstPage;
    });
    ref.onDispose(dispose);
  }

  int get notificationsPerFetch =>
      ref.read(notificationsRepositoryProvider).notificationsPerFetch;

  Future<void> _fetchItems(int pageKey) async {
    try {
      // get last notification from the currently displaying list
      final currentNotificationList = itemList ?? [];
      final lastNotification =
          currentNotificationList.isEmpty ? null : currentNotificationList.last;

      // load next notifications
      final nextNotificationList = await ref
          .read(notificationsRepositoryProvider)
          .fetchNotificationList((lastNotification?.id));

      // pre load users
      await Future.wait(
        nextNotificationList.map((notification) =>
            ref.read(userStreamProvider(notification.notifierId).future)),
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
