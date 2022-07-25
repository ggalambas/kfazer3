import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Notification icon with notifications count badge
class NotificationsIcon extends ConsumerWidget {
  const NotificationsIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsCountValue =
        ref.watch(unreadNotificationCountStreamProvider);
    final notificationsCount = notificationsCountValue.valueOrNull ?? 0;
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
