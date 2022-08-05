import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_screen_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import '../../../../common_widgets/details_bar.dart';

class AccountDetailsScreen extends ConsumerWidget {
  const AccountDetailsScreen({super.key});

  void deleteAccount(BuildContext context, Reader read) async {
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
    return Scaffold(
      appBar: DetailsBar(
        loading: state.isLoading,
        title: context.loc.account,
        onEdit: () => context.goNamed(
          AppRoute.accountDetails.name,
          queryParams: {'editing': 'true'},
        ),
        deleteText: context.loc.deleteAccount,
        onDelete: () => deleteAccount(context, ref.read),
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxContentWidth: Breakpoint.tablet,
          padding: EdgeInsets.all(kSpace * 2),
          child: Column(
            children: [
              Avatar.fromUser(user, radius: kSpace * 10),
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
      ),
    );
  }
}
