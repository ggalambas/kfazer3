import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar/user_avatar.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  void edit(BuildContext context) {
    context.goNamed(
      AppRoute.account.name,
      queryParams: {'editing': 'true'},
    );
  }

  void delete(BuildContext context, WidgetRef ref) async {
    final delete = await showAlertDialog(
      context: context,
      title: context.loc.areYouSure,
      cancelActionText: context.loc.cancel,
      defaultActionText: context.loc.delete,
    );
    if (delete == true) {
      ref.read(accountControllerProvider.notifier).deleteUser();
    }
  }

  void signOut(BuildContext context, WidgetRef ref) async {
    final logout = await showAlertDialog(
      context: context,
      title: context.loc.areYouSure,
      cancelActionText: context.loc.cancel,
      defaultActionText: context.loc.signOut,
    );
    if (logout == true) {
      ref.read(accountControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final user = ref.watch(currentUserStateProvider);
    final state = ref.watch(accountControllerProvider);

    return ResponsiveScaffold(
      padding: EdgeInsets.all(kSpace * 2),
      appBar: DetailsBar(
        loading: state.isLoading,
        title: context.loc.account,
        onEdit: () => edit(context),
        deleteText: context.loc.deleteAccount,
        onDelete: () => delete(context, ref),
      ),
      rail: DetailsRail(
        title: context.loc.account,
        loading: state.isLoading,
        editText: context.loc.editAccount,
        onEdit: () => edit(context),
        deleteText: context.loc.deleteAccount,
        onDelete: () => delete(context, ref),
      ),
      builder: (topPadding) => ListView(
        padding: EdgeInsets.only(top: topPadding),
        children: [
          UserAvatar(user, radius: kSpace * 10, dialogOnTap: false),
          Space(4),
          TextFormField(
            enabled: false,
            initialValue: user.name,
            decoration: InputDecoration(
              labelText: context.loc.displayName,
            ),
          ),
          Space(),
          TextFormField(
            enabled: false,
            initialValue: user.phoneNumber.toString(),
            decoration: InputDecoration(
              labelText: context.loc.phoneNumber,
            ),
          ),
          Space(2),
          Align(
            alignment: Alignment.centerRight,
            child: LoadingElevatedButton(
              loading: state.isLoading,
              onPressed: () => signOut(context, ref),
              style: ElevatedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
              ),
              child: Text(context.loc.signOut),
            ),
          ),
        ],
      ),
    );
  }
}
