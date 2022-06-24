import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/primary_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

import 'sign_in_screen.dart';

class PhoneNumberSignInPage extends StatelessWidget {
  const PhoneNumberSignInPage({super.key});

  void goToVerification(BuildContext context) => context.goNamed(
        AppRoute.signInSubRoute.name,
        params: {'subRoute': SignInSubRoute.verification.name},
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('phone number input'.hardcoded),
            Space(4),
            PrimaryButton(
              onPressed: () => goToVerification(context),
              text: 'Sign In'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}
