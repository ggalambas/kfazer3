import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  void signOut(BuildContext context, WidgetRef ref) async {
    final logout = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Logout'.hardcoded,
    );
    if (logout == true) {
      ref.read(accountScreenControllerProvider.notifier).signOut();
      //TODO: only pop on success
      // context.goNamed(AppRoute.signIn.name);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(accountScreenControllerProvider,
        (previousState, state) {
      if (!state.isRefreshing && state.hasError) {
        showExceptionAlertDialog(
          context: context,
          title: 'Error'.hardcoded,
          exception: state.error,
        );
      }
    });
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'.hardcoded),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed(AppRoute.settings.name),
          ),
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: state.isLoading ? null : () => signOut(context, ref),
          child: Text('Sign out'.hardcoded),
        ),
      ),
    );
  }
}
