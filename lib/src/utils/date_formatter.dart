import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/date_time_x.dart';

String formatDate(BuildContext context, DateTime timestamp) {
  final now = DateTime.now();
  return timestamp.isAtSameDayAs(now)
      ? context.loc.today
      : timestamp.isAtSameYearAs(now)
          ? DateFormat.MMMEd().format(timestamp)
          : DateFormat.yMMMEd().format(timestamp);
}

String formatTime(DateTime timestamp) {
  return DateFormat.Hm().format(timestamp);
}
