/// Class representing a notifications.
class Notification {
  /// Unique notification id
  final String id;

  /// Notification sender user id
  final String notifierId;

  final DateTime timestamp;
  final String description;
  final String deepLink;

  Notification({
    required this.id,
    required this.notifierId,
    required this.timestamp,
    required this.description,
    required this.deepLink,
  });

  //TODO enable deep linking
  //* https://docs.flutter.dev/development/ui/navigation/deep-linking
}
