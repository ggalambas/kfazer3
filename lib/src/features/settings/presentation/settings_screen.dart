import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Settings'.hardcoded)),
      body: ResponsiveCenter(
        child: ListView(
          children: [
            ListTile(
              onTap: () => context.goNamed(AppRoute.account.name),
              leading: Avatar.fromUser(user),
              title: Text(user.name),
              subtitle: Text(user.phoneNumber),
            ),
            const Divider(),
            SelectionSettingTile(
              icon: Icons.workspaces,
              title: 'Open on start'.hardcoded,
              description: 'Page to show when oppening the app'.hardcoded,
              options: OpenOnStart.values,
            ),
            SelectionSettingTile(
              icon: Icons.brightness_4,
              title: 'Theme'.hardcoded,
              options: ThemeMode.values,
            ),
            SelectionSettingTile(
              icon: Icons.language,
              title: 'Language'.hardcoded,
              options: Language.values,
            ),
            ListTile(
              onTap: () => showNotImplementedAlertDialog(context: context),
              leading: const Icon(Icons.notifications),
              title: Text('Notifications'.hardcoded),
              subtitle: Text('Open system settings'.hardcoded),
            ),
            ListTile(
              onTap: () => showNotImplementedAlertDialog(context: context),
              leading: const Icon(Icons.people),
              title: Text('Contact us'.hardcoded),
              subtitle: Text('Questions? Need help?'.hardcoded),
            ),
            ListTile(
              onTap: () => showNotImplementedAlertDialog(context: context),
              leading: const Icon(Icons.description),
              title: Text('Policies'.hardcoded),
              subtitle: Text('Privacy & Terms'.hardcoded),
            ),
            //TODO move to workspace preferences
            // ListTile(
            //   onTap: () => showNotImplementedAlertDialog(context: context),
            //   leading: const Icon(Icons.description),
            //   title: Text('Sheet template'.hardcoded),
            // ),
            // ListTile(
            //   onTap: () => showNotImplementedAlertDialog(context: context),
            //   leading: const Icon(Icons.download),
            //   title: Text('Export'.hardcoded),
            //   subtitle: Text('Export workspace in XXX format'.hardcoded),
            // ),
          ],
        ),
      ),
    );
  }
}
