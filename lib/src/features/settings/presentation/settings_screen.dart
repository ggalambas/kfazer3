import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStateProvider);
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
            Consumer(
              builder: (context, ref, _) => SelectionSettingTile<OpenOnStart>(
                selected: ref.watch(openOnStartStateProvider),
                onChanged: (value) =>
                    ref.read(settingsRepositoryProvider).setOpenOnStart(value),
                options: OpenOnStart.values,
                icon: Icons.workspaces,
                title: 'Open on start'.hardcoded,
                description: 'Page to show when oppening the app'.hardcoded,
              ),
            ),
            Consumer(
              builder: (context, ref, _) => SelectionSettingTile<ThemeMode>(
                selected: ref.watch(themeModeStateProvider),
                onChanged: (value) =>
                    ref.read(settingsRepositoryProvider).setThemeMode(value),
                options: ThemeMode.values,
                icon: Icons.brightness_4,
                title: 'Theme'.hardcoded,
              ),
            ),
            //TODO languages
            Consumer(
              builder: (context, ref, _) => SelectionSettingTile<Language>(
                selected: ref.watch(languageStateProvider),
                onChanged: (value) =>
                    ref.read(settingsRepositoryProvider).setLanguage(value),
                options: Language.values,
                icon: Icons.language,
                title: 'Language'.hardcoded,
              ),
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
