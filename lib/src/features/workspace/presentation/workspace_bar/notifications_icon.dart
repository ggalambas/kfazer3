import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

/// Notification icon with notifications count badge
class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    const notificationsCount = 3;
    return Stack(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.pushNamed(AppRoute.notifications.name),
          ),
        ),
        if (notificationsCount > 0)
          Positioned(
            top: kSpace / 2,
            right: kSpace / 2,
            child: const NotificationsIconBadge(itemsCount: notificationsCount),
          ),
      ],
    );
  }
}

/// Icon badge showing the items count
class NotificationsIconBadge extends StatelessWidget {
  final int itemsCount;
  const NotificationsIconBadge({super.key, required this.itemsCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: kSpace * 2,
      height: kSpace * 2,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$itemsCount',
          textAlign: TextAlign.center,
          // Force textScaleFactor to 1.0 irrespective of the device's
          // textScaleFactor. This is to prevent the text from growing bigger
          // than the available space.
          textScaleFactor: 1.0,
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
