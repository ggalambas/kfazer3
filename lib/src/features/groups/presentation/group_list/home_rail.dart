import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_button.dart';
//!
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

/// Custom [Rail] widget that is used by the [GroupListScreen].
/// It shows the following actions:
/// - Notifications button
/// - Settings button
class HomeRail extends StatelessWidget {
  const HomeRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Rail(
      title: context.loc.appTitle,
      actions: [
        const NotificationsTextButton(),
        TextButton(
          onPressed: () => context.goNamed(AppRoute.settings.name),
          child: Text(context.loc.settings),
        ),
      ],
    );
  }
}
