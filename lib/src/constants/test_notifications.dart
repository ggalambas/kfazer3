import 'dart:math';

import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

/// Test notifications to be used until a data source is implemented
final kTestNotifications = List.generate(
  15,
  (i) => Notification(
    id: '$i',
    notifierId: Random().nextInt(kTestUsers.length).toString(),
    timestamp: DateTime.now().subtract(Duration(
      days: Random().nextInt(i + 1),
      minutes: Random().nextInt(i + 1),
    )),
    description: 'You\'ve been invited to join workspace 0',
    path: '/w/0',
  ),
);
