import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_layout.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

import 'sign_in_screen.dart';

class PhoneNumberVerificationPage extends StatefulWidget {
  const PhoneNumberVerificationPage({super.key});

  @override
  State<PhoneNumberVerificationPage> createState() =>
      _PhoneNumberVerificationPageState();
}

class _PhoneNumberVerificationPageState
    extends State<PhoneNumberVerificationPage> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  String get code => codeController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  // var _submitted = false;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void goBack(BuildContext context) => context.goNamed(
        AppRoute.signInSubRoute.name,
        params: {'subRoute': SignInSubRoute.phoneNumber.name},
      );

  void verify(BuildContext context) {
    FocusScope.of(context).nextFocus();
    context.goNamed(
      AppRoute.signInSubRoute.name,
      params: {'subRoute': SignInSubRoute.profile.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        return false;
      },
      child: SignInLayout(
        formKey: formKey,
        title: 'Verifying your number'.hardcoded,
        description: 'We have sent a code to +351912345678'.hardcoded,
        form: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Code'.hardcoded),
            ),
            Space(3),
            LoadingOutlinedButton(
              text: 'Resend SMS (30)'.hardcoded,
              onPressed: () => showNotImplementedAlertDialog(context: context),
            ),
            LoadingElevatedButton(
              text: 'Sign in'.hardcoded,
              onPressed: () => verify(context),
            ),
          ],
        ),
      ),
    );
  }
}
