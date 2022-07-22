import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Notification icon with notifications count badge
class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    const notificationsCount = 10;
    return IconButton(
      tooltip: 'Notifications'.hardcoded,
      icon: Badge(
        padding: EdgeInsets.symmetric(horizontal: kSpace / 2),
        animationType: BadgeAnimationType.scale,
        borderRadius: BorderRadius.circular(kSpace),
        showBadge: notificationsCount > 0,
        shape: notificationsCount > 9 ? BadgeShape.square : BadgeShape.circle,
        badgeContent: Text(
          notificationsCount > 99 ? '99+' : '$notificationsCount',
          style: context.textTheme.labelSmall!.copyWith(
            color: Colors.white,
          ),
        ),
        child: const Icon(Icons.notifications),
      ),
      onPressed: () => context.pushNamed(AppRoute.notifications.name),
    );
  }
}
