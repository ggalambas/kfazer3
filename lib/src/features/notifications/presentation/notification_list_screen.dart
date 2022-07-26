import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/error_message_widget.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/domain/readable_notification.dart';
import 'package:kfazer3/src/features/notifications/presentation/notification_card.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

import 'notification_list_skeleton.dart';
import 'notification_paging_controller.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  void markAsRead(WidgetRef ref, Notification notification) => ref
      .read(notificationsRepositoryProvider)
      .setNotification(notification.markAsRead());

  void markAllAsRead(
    WidgetRef ref,
    AsyncValue<List<Notification>> notificationListValue,
  ) async {
    final notificationList = notificationListValue.valueOrNull;
    notificationList?.forEach((n) => markAsRead(ref, n));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(notificationPagingControllerProvider);
    final isFirstPageLoading = ref.watch(isNotificationPagingLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.hardcoded),
        actions: [
          IconButton(
            tooltip: 'Mark all as read'.hardcoded,
            // onPressed: () => markAllAsRead(ref, notificationListValue),
            onPressed: () => showNotImplementedAlertDialog(context: context),
            icon: const Icon(Icons.playlist_add_check),
          ),
          SingleChildMenuButton(
            onSelected: () => showNotImplementedAlertDialog(context: context),
            child: const Text('Settings'),
          ),
        ],
      ),
      //TODO pull to refresh
      body: ResponsiveCenter(
        padding: EdgeInsets.symmetric(vertical: kSpace),
        child: PagedListView<int, Notification>(
          pagingController: pagingController,
          physics:
              isFirstPageLoading ? const NeverScrollableScrollPhysics() : null,
          builderDelegate: PagedChildBuilderDelegate(
            firstPageProgressIndicatorBuilder: (context) {
              return const NotificationListSkeleton();
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
                message: 'You have no notifications'.hardcoded,
                illustration: UnDrawIllustration.floating,
              );
            },
            itemBuilder: (context, notification, _) {
//TODO divider
              return NotificationCard(
                notification: notification,
                onPressed: (notification) {
                  markAsRead(ref, notification);
                  context.go(notification.path);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
