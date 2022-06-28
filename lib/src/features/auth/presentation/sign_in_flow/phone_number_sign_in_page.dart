import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class PhoneNumberSignInPage extends StatefulWidget {
  const PhoneNumberSignInPage({super.key});

  @override
  State<PhoneNumberSignInPage> createState() => _PhoneNumberSignInPageState();
}

class _PhoneNumberSignInPageState extends State<PhoneNumberSignInPage> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  String get phoneNumber => phoneNumberController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  // var _submitted = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void goToVerification(BuildContext context) => context.goNamed(
        AppRoute.signInSubRoute.name,
        params: {'subRoute': SignInSubRoute.verification.name},
      );

  @override
  Widget build(BuildContext context) {
    return SignInLayout(
      formKey: formKey,
      title: 'Welcome to KFazer'.hardcoded,
      description: 'We will need to verify your phone number.\n'
              'On pressing "next", you are accepting our Terms of Use '
              'and agreeing with our Privacy Policy.'
          .hardcoded,
      form: [
        //TODO country code
        TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number'.hardcoded,
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
        ),
        Space(3),
        LoadingElevatedButton(
          text: 'Next'.hardcoded,
          onPressed: () => goToVerification(context),
        ),
      ],
    );
  }
}
