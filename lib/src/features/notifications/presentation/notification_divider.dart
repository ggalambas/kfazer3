import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/date_formatter.dart';
import 'package:smart_space/smart_space.dart';

class NotificationDivider extends StatelessWidget {
  final DateTime date;
  const NotificationDivider({super.key, required this.date});

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
            formatDate(context, date).toUpperCase(),
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
