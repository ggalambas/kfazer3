import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/features/settings/presentation/selection_setting_tile.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/language.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/routing/website.dart';
import 'package:kfazer3/src/theme/loc_theme_mode.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.settings)),
      body: ResponsiveCenter(
        child: ListView(
          children: [
            ListTile(
              onTap: () => context.goNamed(AppRoute.accountDetails.name),
              leading: Avatar.fromUser(user),
              title: Text(user.name),
              subtitle: Text(user.phoneNumber.number),
            ),
            const Divider(),
            Consumer(
              builder: (context, ref, _) => SelectionSettingTile<LocThemeMode>(
                selected: ref.watch(themeModeStateProvider),
                onChanged: (value) =>
                    ref.read(settingsRepositoryProvider).setThemeMode(value),
                options: LocThemeMode.values,
                icon: Icons.brightness_4,
                title: context.loc.theme,
              ),
            ),
            Consumer(
              builder: (context, ref, _) => SelectionSettingTile<Language>(
                selected: ref.watch(languageStateProvider),
                onChanged: (value) =>
                    ref.read(settingsRepositoryProvider).setLanguage(value),
                options: Language.values,
                icon: Icons.language,
                title: context.loc.language,
              ),
            ),
            ListTile(
              onTap: () => AppSettings.openNotificationSettings(),
              leading: const Icon(Icons.notifications),
              title: Text(context.loc.notifications),
              subtitle: Text(context.loc.notificationSettingsDescription),
            ),
            ListTile(
              onTap: () => launchUrl(Website.sheetTemplate),
              leading: const Icon(Icons.calendar_view_month),
              title: Text(context.loc.sheetTemplate),
            ),
            ListTile(
              onTap: () => launchUrl(Website.contactUs),
              leading: const Icon(Icons.people),
              title: Text(context.loc.contactUs),
              subtitle: Text(context.loc.contactUsDescription),
            ),
            ListTile(
              onTap: () => launchUrl(Website.policies),
              leading: const Icon(Icons.description),
              title: Text(context.loc.policies),
              subtitle: Text(context.loc.policiesDescription),
            ),
          ],
        ),
      ),
    );
  }
}
