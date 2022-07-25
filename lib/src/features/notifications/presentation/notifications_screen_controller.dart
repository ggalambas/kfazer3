import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

final notificationListProvider = StateNotifierProvider.autoDispose<
    NotificationsScreenController, AsyncValue<List<Notification>>>(
  (ref) => NotificationsScreenController(ref.read),
);

class NotificationsScreenController
    extends StateNotifier<AsyncValue<List<Notification>>> {
  final Reader read;
  final pagingController = PagingController<int, Notification>(firstPageKey: 1);

  NotificationsScreenController(this.read) : super(const AsyncValue.loading()) {
    pagingController.addStatusListener(updateState);
    pagingController.addPageRequestListener((_) => _fetchItems());
  }

  void updateState(PagingStatus status) {
    print(status);
    switch (status) {
      case PagingStatus.loadingFirstPage:
        state = const AsyncValue.loading();
        break;
      case PagingStatus.firstPageError:
        state = AsyncValue.error(pagingController.error);
        break;
      default:
        state = AsyncValue.data(pagingController.itemList ?? []);
    }
  }

  Future<void> _fetchItems() async {
    try {
      print('fetch');
      final notificationList = pagingController.itemList ?? [];
      final lastNotification =
          notificationList.isEmpty ? null : notificationList.last;
      final newNotificationList = await read(
          notificationListStreamProvider(lastNotification?.id).future);
      print(newNotificationList.length);

      // final noMoreItems = newItems.length < itemCount;
      final noMoreItems = newNotificationList.isEmpty;
      noMoreItems
          ? pagingController.appendLastPage(newNotificationList)
          : pagingController.appendPage(newNotificationList, 1);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
