/// Class representing the existing notifications range.
class NotificationInterval {
  final int lastId;
  final int firstId;

  NotificationInterval(this.lastId, this.firstId);

  factory NotificationInterval.fromString(String lastId, String firstId) =>
      NotificationInterval(int.parse(lastId), int.parse(firstId));

  List<int> get ids => List.generate(
        lastId - firstId + 1,
        (i) => lastId - i,
      );
}
