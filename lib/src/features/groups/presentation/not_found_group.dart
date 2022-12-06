import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

class NotFoundGroup extends ConsumerWidget {
  const NotFoundGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: NotFoundWidget(
        message: context.loc.groupNoAccess,
      ),
    );
  }
}
