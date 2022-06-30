import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';

import 'pages/account_setup_page.dart';
import 'pages/phone_sign_in_page.dart';
import 'pages/phone_verification_page.dart';

/// The three sub-routes that are presented as part of the sign in flow.
enum SignInPage { phoneNumber, verification, account }

/// This is the root widget of the sign in flow, which is composed of 3 pages:
/// 1. Phone number sign in page
/// 2. Phone number verification page
/// 3. Profile creation page
///
///! The logic for the entire flow is implemented in the [SignInScreenController],
/// while UI updates are handled by a [PageController].
class SignInScreen extends ConsumerStatefulWidget {
  final SignInPage page;
  const SignInScreen({super.key, required this.page});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final controller = PageController(initialPage: widget.page.index);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SignInScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // perform a nice scroll animation to reveal the next page
    if (controller.hasClients && controller.position.hasViewportDimension) {
      controller.animateToPage(
        widget.page.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      signInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    // Note: only the currently active page will be visible.
    return WillPopScope(
      onWillPop: () async {
        switch (widget.page) {
          case SignInPage.phoneNumber:
            return true;
          case SignInPage.verification:
          case SignInPage.account:
            context.goNamed(AppRoute.signIn.name);
            return false;
        }
      },
      child: TapToUnfocus(
        child: Scaffold(
          body: PageView(
            // disable swiping between pages
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              //TODO form validations
              PhoneSignInPage(
                onSuccess: () => context.goNamed(
                  AppRoute.signInPage.name,
                  params: {'page': SignInPage.verification.name},
                ),
              ),
              PhoneVerificationPage(
                onSuccess: () {
                  if (ref.read(authRepositoryProvider).currentUser == null) {
                    context.goNamed(
                      AppRoute.signInPage.name,
                      params: {'page': SignInPage.account.name},
                    );
                  }
                },
              ),
              const AccountSetupPage(),
            ],
          ),
        ),
      ),
    );
  }
}
