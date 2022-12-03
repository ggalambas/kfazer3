import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/application/notifications_service.dart';

final notificationListControllerProvider =
    StateNotifierProvider.autoDispose<NotificationListController, AsyncValue>(
  (ref) => NotificationListController(
    service: ref.watch(notificationsServiceProvider),
  ),
);

class NotificationListController extends StateNotifier<AsyncValue> {
  final NotificationsService service;

  NotificationListController({required this.service})
      : super(const AsyncValue.data(null));

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(service.markAllAsRead);
  }
}
