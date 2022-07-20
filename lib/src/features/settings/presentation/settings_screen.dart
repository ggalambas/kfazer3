import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
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
            ListTile(
              onTap: () => showNotImplementedAlertDialog(context: context),
              leading: const Icon(Icons.view_agenda),
              title: Text('Density'.hardcoded),
              subtitle: Text('Task cards density'.hardcoded),
              // TODO complete the dropdown and design it
              trailing: DropdownButton(
                value: 0,
                onChanged: (value) {},
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Compact'.hardcoded),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Confortable'.hardcoded),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () => showNotImplementedAlertDialog(context: context),
              leading: const Icon(Icons.view_agenda),
              title: Text('Open on start'.hardcoded),
              subtitle: Text('Page to show when oppening the app'.hardcoded),
              // TODO complete the dropdown and design it
              trailing: DropdownButton(
                value: 0,
                onChanged: (value) {},
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Home'.hardcoded),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Last workspace'.hardcoded),
                  ),
                ],
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
              title: Text('Terms and Privacy Policy'.hardcoded),
            ),
          ],
        ),
      ),
    );
  }
}
