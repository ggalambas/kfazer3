import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/account/editing_account_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'account_bar.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  void signOut() async {
    final logout = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Sign Out'.hardcoded,
    );
    if (logout == true) {
      ref.read(accountScreenControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final isEditing = ref.watch(accountEditStateProvider);
    if (isEditing) return const EditingAccountScreen();

    final user = ref.watch(currentUserStateProvider);
    final state = ref.watch(accountScreenControllerProvider);
    return TapToUnfocus(
      child: Scaffold(
          appBar: AccountBar(loading: state.isLoading),
          body: ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: EdgeInsets.all(kSpace * 2),
            child: ListView(
              children: [
                Column(
                  children: [
                    Avatar.fromUser(user, radius: kSpace * 10),
                    Space(4),
                    TextFormField(
                      enabled: false,
                      initialValue: user.name,
                      decoration: InputDecoration(
                        labelText: 'Display name'.hardcoded,
                      ),
                    ),
                    Space(),
                    TextFormField(
                      enabled: false,
                      initialValue: user.phoneNumber.toString(),
                      decoration: InputDecoration(
                        labelText: 'Phone number'.hardcoded,
                      ),
                    ),
                  ],
                ),
                Space(2),
                Align(
                  alignment: Alignment.centerRight,
                  child: LoadingElevatedButton(
                    isLoading: state.isLoading,
                    onPressed: signOut,
                    child: Text('Sign out'.hardcoded),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
