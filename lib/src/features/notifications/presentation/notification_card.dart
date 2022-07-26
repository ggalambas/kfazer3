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
  final void Function(Notification notification) onPressed;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onPressed,
  });

  //TODO Check if jm uses 24h format on portuguese location. If not, use Hm
  String formatTime(DateTime timestamp) => DateFormat.jm().format(timestamp);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => onPressed(notification),
      child: Material(
        color: notification.read ? null : Colors.red.withOpacity(0.12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: kSpace,
            horizontal: kSpace * 2,
          ),
          child: Row(
            children: [
              //TODO user loading
              Consumer(
                builder: (context, ref, child) {
                  final userValue =
                      ref.watch(userStreamProvider(notification.notifierId));
                  return AsyncValueWidget<AppUser?>(
                    value: userValue,
                    data: (user) => Avatar.fromUser(user),
                  );
                },
              ),
              Space(2),
              Expanded(child: Text(notification.description)),
              Space(2),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatTime(notification.timestamp),
                    style: context.textTheme.labelMedium!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (!notification.read) const UnreadNotificationDot(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnreadNotificationDot extends StatelessWidget {
  const UnreadNotificationDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSpace * 0.75,
      height: kSpace * 0.75,
      margin: EdgeInsets.only(
        top: kSpace / 2,
        right: kSpace / 2,
      ),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
