import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/date_timeless.dart';
import 'package:smart_space/smart_space.dart';

class NotificationDivider extends StatelessWidget {
  final DateTime date;
  const NotificationDivider({super.key, required this.date});

  String formatDate(DateTime timestamp) {
    if (timestamp.timeless == DateTime.now().timeless) return 'Today'.hardcoded;
    return timestamp.year == DateTime.now().year
        ? DateFormat.MMMEd().format(timestamp)
        : DateFormat.yMMMEd().format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: kSpace,
        horizontal: kSpace * 2,
      ),
      child: Row(
        children: [
          Text(
            formatDate(date).toUpperCase(),
            style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          Space(),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
