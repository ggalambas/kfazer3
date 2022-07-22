import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/team/data/users_repository.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Used to show a single notification inside a card.
class NotificationCard extends ConsumerWidget {
  final Notification notification;
  final VoidCallback onPressed;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onPressed,
  });

  //TODO Check if jm uses 24h format on portuguese location. If not, use Hm
  String formatTime(DateTime timestamp) => DateFormat.jm().format(timestamp);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO skeleton loader
    final userValue = ref.watch(userFutureProvider(notification.notifierId));
    return AsyncValueWidget<AppUser?>(
        value: userValue,
        data: (user) {
          return InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: kSpace,
                horizontal: kSpace * 2,
              ),
              child: Row(
                children: [
                  Avatar.fromUser(user),
                  Space(2),
                  Expanded(child: Text(notification.description)),
                  Space(2),
                  Text(
                    formatTime(notification.timestamp),
                    style: context.textTheme.labelMedium!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
