import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  String formatDate(DateTime timestamp) => DateFormat.MMMEd().format(timestamp);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationListValue = ref.watch(notificationListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.hardcoded),
        actions: [
          IconButton(
            onPressed: () => showNotImplementedAlertDialog(context: context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: AsyncValueWidget<List<Notification>>(
        value: notificationListValue,
        data: (notificationList) {
          if (notificationList.isEmpty) {
            return EmptyPlaceholder(
              message: 'You have no notifications'.hardcoded,
              illustration: UnDrawIllustration.floating,
            );
          }
          //TODO sort notifications and group them by day
          return CustomScrollView(
            slivers: [
              ResponsiveSliverCenter(
                padding: EdgeInsets.all(kSpace * 2),
                child: Column(
                  children: [
                    for (final notification in notificationList) ...[
                      Row(
                        children: [
                          Text(
                            formatDate(notification.timestamp).toUpperCase(),
                            style: context.textTheme.labelMedium!.copyWith(
                              //TODO use this for the color??
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Space(),
                          //TODO Horizontal divider workaround
                          Expanded(child: Column(children: const [Divider()])),
                        ],
                      ),
                      NotificationCard(
                        notification: notification,
                        onPressed: () => context.goNamed(notification.deepLink),
                      ),
                    ]
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
