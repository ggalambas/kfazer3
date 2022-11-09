import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/trail.dart';
import 'package:kfazer3/src/common_widgets/user_avatar.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_screen_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class AccountDetailsScreen extends ConsumerWidget {
  const AccountDetailsScreen({super.key});

  void edit(BuildContext context) {
    context.goNamed(
      AppRoute.accountDetails.name,
      queryParams: {'editing': 'true'},
    );
  }

  void delete(BuildContext context, Reader read) async {
    final delete = await showAlertDialog(
      context: context,
      title: context.loc.areYouSure,
      cancelActionText: context.loc.cancel,
      defaultActionText: context.loc.delete,
    );
    if (delete == true) {
      read(accountDetailsScreenControllerProvider.notifier).deleteUser();
    }
  }

  void signOut(BuildContext context, Reader read) async {
    final logout = await showAlertDialog(
      context: context,
      title: context.loc.areYouSure,
      cancelActionText: context.loc.cancel,
      defaultActionText: context.loc.signOut,
    );
    if (logout == true) {
      read(accountDetailsScreenControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountDetailsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final user = ref.watch(currentUserStateProvider);
    final state = ref.watch(accountDetailsScreenControllerProvider);
    final maybeEdit = state.isLoading ? null : () => edit(context);
    final maybeDelete =
        state.isLoading ? null : () => delete(context, ref.read);

    return ResponsiveScaffold(
      appBar: DetailsBar(
        loading: state.isLoading,
        title: context.loc.account,
        onEdit: () => edit(context),
        deleteText: context.loc.deleteAccount,
        onDelete: () => delete(context, ref.read),
      ),
      rail: Trail(
        title: context.loc.account,
        actions: [
          TextButton(
            onPressed: maybeEdit,
            child: Text(context.loc.editAccount),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            onPressed: maybeDelete,
            child: Text(context.loc.deleteAccount),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                onPressed: () => signOut(context, ref.read),
                child: Text(context.loc.signOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
