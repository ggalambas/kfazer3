import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';
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
    //TODO get user from notifierId
    final user = ref.watch(authRepositoryProvider).currentUser;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: kSpace * 2),
        child: Row(
          children: [
            Avatar.fromUser(user),
            Space(2),
            Expanded(child: Text(notification.description)),
            Text(formatTime(notification.timestamp)),
          ],
        ),
      ),
    );
  }
}
