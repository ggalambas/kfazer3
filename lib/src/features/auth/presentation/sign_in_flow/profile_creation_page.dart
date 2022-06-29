import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class ProfileCreationPage extends StatefulWidget {
  const ProfileCreationPage({super.key});

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final nameController = TextEditingController();

  String get name => nameController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  // var _submitted = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void signOut(BuildContext context) => context.goNamed(
        AppRoute.signInSubRoute.name,
        params: {'subRoute': SignInSubRoute.phoneNumber.name},
      );

  void createProfile(BuildContext context) {
    context.goNamed(AppRoute.home.name);
    nameNode
      ..nextFocus()
      ..unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        signOut(context);
        return false;
      },
      child: SignInLayout(
        formKey: formKey,
        title: 'Set up your profile'.hardcoded,
        description: 'Choose a name that others will recognize you.'.hardcoded,
        formFields: [
          TextField(
            focusNode: nameNode,
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Display name'.hardcoded,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(kSpace),
              ),
            ),
          ),
        ],
        cta: [
          LoadingElevatedButton(
            text: 'Save'.hardcoded,
            onPressed: () => createProfile(context),
          ),
        ],
      ),
    );
  }
}
