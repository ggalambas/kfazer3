import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/not_found_widget.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class NotFoundWorkspace extends ConsumerWidget {
  const NotFoundWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: NotFoundWidget(
        // reset last openned workspace
        onLeave: () =>
            ref.read(settingsRepositoryProvider).removeLastWorkspaceId(),
        message: 'You do not have access to this workspace. '
                'Please contact a member to add you to their team'
            .hardcoded,
      ),
    );
  }
}
