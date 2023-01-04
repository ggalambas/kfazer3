import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/features/notifications/application/notifications_service.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
import 'package:kfazer3/src/features/users/data/users_repository.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/date_formatter.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref
            .watch(notificationStreamProvider(this.notification.id))
            .valueOrNull ??
        this.notification;

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
              Consumer(
                builder: (context, ref, _) {
                  final user = ref
                      .watch(userStreamProvider(notification.notifierId))
                      .valueOrNull;
                  return UserAvatar(user);
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
