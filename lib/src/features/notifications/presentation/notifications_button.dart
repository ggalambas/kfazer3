import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_count_badge.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

/// Notification icon button with notifications count badge
class NotificationsIconButton extends StatelessWidget {
  const NotificationsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.loc.notifications,
      icon: const NotificationsCountBadge(
        child: Icon(Icons.notifications),
      ),
      onPressed: () => context.pushNamed(AppRoute.notifications.name),
    );
  }
}

/// Notification text button with notifications count badge
class NotificationsTextButton extends StatelessWidget {
  const NotificationsTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: NotificationsCountBadge(
        position: (count) {
          if (count < 10) return const BadgePosition(end: -18);
          if (count < 100) return const BadgePosition(end: -26);
          return const BadgePosition(end: -34);
        },
        child: Text(context.loc.notifications),
      ),
      onPressed: () => context.pushNamed(AppRoute.notifications.name),
    );
  }
}
