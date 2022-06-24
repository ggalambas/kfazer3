import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_bar/notifications_icon.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum HomeMenuOption { settings }

/// Custom [AppBar] widget that is used by the [WorkspaceListScreen].
/// It shows the following actions:
/// - Account button
/// - Notifications button
/// - Settings button
class HomeBar extends StatelessWidget with PreferredSizeWidget {
  const HomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    const user = AppUser(
      id: '123',
      name: 'Tareco Buito',
      phoneNumber: '+351912345678',
    );
    // MediaQuery is used on the assumption that the widget takes up the full
    // width of the screen. If that's not the case, LayoutBuilder should be
    // used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    final avatar = Avatar.fromUser(user);
    return AppBar(
      title: Text('KFazer'.hardcoded),
      centerTitle: screenWidth >= Breakpoint.tablet,
      actions: [
        const NotificationsIcon(),
        IconButton(
          icon: avatar,
          iconSize: avatar.diameter,
          onPressed: () => context.goNamed(AppRoute.account.name),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
