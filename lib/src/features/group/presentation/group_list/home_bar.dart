import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_icon.dart'; //!
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum HomeMenuOption { settings }

/// Custom [AppBar] widget that is used by the [GroupListScreen].
/// It shows the following actions:
/// - Account button
/// - Notifications button
/// - Settings button
class HomeBar extends StatelessWidget with PreferredSizeWidget {
  const HomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery is used on the assumption that the widget takes up the full
    // width of the screen. If that's not the case, LayoutBuilder should be
    // used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(context.loc.appTitle),
      centerTitle: screenWidth >= Breakpoint.tablet,
      actions: [
        const NotificationsIcon(),
        SingleChildMenuButton(
          onSelected: () => context.goNamed(AppRoute.settings.name),
          child: Text(context.loc.settings),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
