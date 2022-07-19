import 'package:kfazer3/src/features/notifications/domain/notification.dart';

/// Test notifications to be used until a data source is implemented
final kTestNotifications = List.generate(
  15,
  (i) => Notification(
    id: '$i',
    notifierId: '$i',
    timestamp: DateTime.now().subtract(Duration(days: i)),
    description: 'You\'ve been invited to join workspace 0',
    // TODO deep link instead of navigation?
    deepLink: '/w/0',
  ),
);
