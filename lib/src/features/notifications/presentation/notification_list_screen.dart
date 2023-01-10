import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/error_message_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/notifications/application/notifications_service.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/presentation/notification_divider.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/date_time_x.dart';
import 'package:smart_space/smart_space.dart';

import 'notification_card.dart';
import 'notification_list_controller.dart';
import 'notification_paging_controller.dart';

class NotificationsListScreen extends ConsumerWidget {
  const NotificationsListScreen({super.key});

  void openNotificationSettings() => AppSettings.openNotificationSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      notificationListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(notificationListControllerProvider);
    final pagingController = ref.watch(notificationPagingControllerProvider);
    DateTime? lastNotificationDate;

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(context.loc.notifications),
        actions: [
          ValueListenableBuilder(
            valueListenable: pagingController,
            builder: (context, _, __) => LoadingIconButton(
              loading: state.isLoading,
              tooltip: context.loc.markAllAsRead,
              onPressed: pagingController.itemList == null
                  ? null
                  : () => ref
                      .read(notificationListControllerProvider.notifier)
                      .markAllAsRead(),
              icon: const Icon(Icons.playlist_add_check),
            ),
          ),
          SingleChildMenuButton(
            onSelected: openNotificationSettings,
            child: Text(context.loc.settings),
          ),
        ],
      ),
      rail: Rail(
        title: context.loc.notifications,
        actions: [
          ValueListenableBuilder(
            valueListenable: pagingController,
            builder: (context, _, __) => LoadingTextButton(
              loading: state.isLoading,
              onPressed: pagingController.itemList == null
                  ? null
                  : () => ref
                      .read(notificationListControllerProvider.notifier)
                      .markAllAsRead(),
              child: Text(context.loc.markAllAsRead),
            ),
          ),
          TextButton(
            onPressed: openNotificationSettings,
            child: Text(context.loc.settings),
          ),
        ],
      ),
      builder: (topPadding) => RefreshIndicator(
        onRefresh: () async => pagingController.refresh(),
        child: ResponsiveCenter(
          padding: EdgeInsets.symmetric(vertical: kSpace),
          child: PagedListView<int, Notification>(
            padding: EdgeInsets.only(top: topPadding),
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
                    ref
                        .read(notificationsServiceProvider)
                        .markNotificationAsRead(notification);
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
