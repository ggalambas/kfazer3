extension DateTimeX on DateTime {
  DateTime get timeless => DateTime(year, month, day);
  bool isAtSameDayAs(DateTime other) => timeless == other.timeless;
  bool isAtSameYearAs(DateTime other) => year == other.year;
}
