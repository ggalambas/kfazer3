import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/localization/localization_context.dart';

class NotFoundTask extends ConsumerWidget {
  const NotFoundTask({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: NotFoundWidget(
        message: context.loc.taskNotFound,
      ),
    );
  }
}
