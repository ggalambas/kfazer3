import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/error_message_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/domain/readable_notification.dart';
import 'package:kfazer3/src/features/notifications/presentation/notification_divider.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/date_timeless.dart';
import 'package:smart_space/smart_space.dart';

import 'notification_card.dart';
import 'notification_paging_controller.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  void markAsRead(WidgetRef ref, Notification notification) => ref
      .read(notificationsRepositoryProvider)
      .setNotification(notification.markAsRead());

  // TODO it's marking just the loaded ones
  void markAllAsRead(WidgetRef ref, List<Notification> notificationList) {
    for (var notification in notificationList) {
      markAsRead(ref, notification);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(notificationPagingControllerProvider);
    DateTime? lastNotificationDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.notifications),
        actions: [
          IconButton(
            tooltip: context.loc.markAllAsRead,
            onPressed: () {
              if (pagingController.itemList != null) {
                markAllAsRead(ref, pagingController.itemList!);
              }
            },
            icon: const Icon(Icons.playlist_add_check),
          ),
          SingleChildMenuButton(
            onSelected: () => AppSettings.openNotificationSettings(),
            child: Text(context.loc.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => pagingController.refresh(),
        child: ResponsiveCenter(
          padding: EdgeInsets.symmetric(vertical: kSpace),
          child: PagedListView<int, Notification>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              firstPageErrorIndicatorBuilder: (context) {
                return Center(
                  child: ErrorMessageWidget(
                    pagingController.error.toString(),
                  ),
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return EmptyPlaceholder(
                  message: context.loc.noNotifications,
                  illustration: UnDrawIllustration.floating,
                );
              },
              itemBuilder: (context, notification, _) {
                final notificationCard = NotificationCard(
                  notification: notification,
                  onPressed: (notification) {
                    markAsRead(ref, notification);
                    context.go(notification.path);
                  },
                );
                if (lastNotificationDate?.timeless !=
                    notification.timestamp.timeless) {
                  lastNotificationDate = notification.timestamp;
                  return Column(
                    children: [
                      NotificationDivider(date: lastNotificationDate!),
                      notificationCard,
                    ],
                  );
                }
                return notificationCard;
              },
            ),
          ),
        ),
      ),
    );
  }
}
