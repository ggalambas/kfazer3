import 'dart:math';

import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/notifications/domain/notification.dart';

/// Test notifications to be used until a data source is implemented
List<Notification> get kTestNotifications => [..._kTestNotifications];
final _kTestNotifications = List.generate(
  100,
  (i) => Notification(
    id: '$i',
    notifierId: Random().nextInt(kTestUsers.length).toString(),
    timestamp: DateTime.now().subtract(Duration(
      days: Random().nextInt(i + 1),
      minutes: Random().nextInt(i + 1),
    )),
    description: 'You\'ve been invited to join workspace 0',
    path: '/g/0',
    read: Random().nextBool(),
  ),
);
