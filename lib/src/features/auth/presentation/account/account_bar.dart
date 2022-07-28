import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class AccountBar extends ConsumerWidget with PreferredSizeWidget {
  final bool loading;
  const AccountBar({super.key, required this.loading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text('Account'.hardcoded),
      actions: [
        IconButton(
          tooltip: 'Edit'.hardcoded,
          onPressed: loading
              ? null
              : () => context.goNamed(
                    AppRoute.account.name,
                    queryParams: {'editing': 'true'},
                  ),
          icon: const Icon(Icons.edit),
        ),
        SingleChildMenuButton(
          onSelected: loading
              ? null
              : () => showNotImplementedAlertDialog(context: context),
          child: Text('Delete account'.hardcoded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EditingAccountBar extends ConsumerWidget with PreferredSizeWidget {
  final bool loading;
  final VoidCallback onSave;

  const EditingAccountBar({
    super.key,
    required this.loading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed:
            loading ? null : () => context.goNamed(AppRoute.account.name),
        icon: const Icon(Icons.close),
      ),
      title: Text('Account'.hardcoded),
      actions: [
        LoadingTextButton(
          isLoading: loading,
          onPressed: onSave,
          child: Text('Save'.hardcoded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
