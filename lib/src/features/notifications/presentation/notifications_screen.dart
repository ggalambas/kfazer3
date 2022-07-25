import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/notifications/domain/readable_notification.dart';
import 'package:kfazer3/src/features/notifications/presentation/notification_divider.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/date_timeless.dart';
import 'package:smart_space/smart_space.dart';

import 'notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

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
    final notificationListValue = ref.watch(notificationListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.hardcoded),
        actions: [
          IconButton(
            tooltip: 'Mark all as read'.hardcoded,
            onPressed: () => markAllAsRead(ref, notificationListValue),
            icon: const Icon(Icons.playlist_add_check),
          ),
          SingleChildMenuButton(
            onSelected: () => showNotImplementedAlertDialog(context: context),
            child: const Text('Settings'),
          ),
        ],
      ),
      //TODO infinite list
      //https://twitter.com/remi_rousselet/status/1307723692441513988
      body: AsyncValueWidget<List<Notification>>(
        value: notificationListValue,
        data: (notificationList) {
          if (notificationList.isEmpty) {
            return EmptyPlaceholder(
              message: 'You have no notifications'.hardcoded,
              illustration: UnDrawIllustration.floating,
            );
          }
          final notificationsGroup =
              notificationList.groupListsBy((n) => n.timestamp.timeless);
          return CustomScrollView(
            slivers: [
              ResponsiveSliverCenter(
                padding: EdgeInsets.symmetric(vertical: kSpace),
                child: Column(
                  children: [
                    for (final date in notificationsGroup.keys) ...[
                      NotificationDivider(date: date),
                      for (final notification in notificationsGroup[date]!) ...[
                        NotificationCard(
                          notification: notification,
                          onPressed: () {
                            markAsRead(ref, notification);
                            context.go(notification.path);
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
