import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/notifications/application/notifications_service.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class NotificationsCountBadge extends ConsumerWidget {
  final BadgePosition Function(int count)? position;
  final Widget? child;
  const NotificationsCountBadge({super.key, this.position, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsCountValue =
        ref.watch(unreadNotificationCountStreamProvider);
    final notificationsCount = notificationsCountValue.valueOrNull ?? 0;
    return Badge(
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
      position: position?.call(notificationsCount),
      child: child,
    );
  }
}
