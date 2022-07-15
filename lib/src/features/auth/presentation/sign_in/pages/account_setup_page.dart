import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

//TODO when poping, it should go to phone sign in page
class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({super.key});

  @override
  ConsumerState<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final nameController = TextEditingController();

  String get name => nameController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void submit(BuildContext context) {
    nameNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(signInControllerProvider.notifier);
    controller.submit(SignInPage.account, name);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    return SignInLayout(
      formKey: formKey,
      title: 'Set up your profile'.hardcoded,
      description: TextSpan(
        text: 'Choose a name that others will recognize you.'.hardcoded,
      ),
      content: [
        TextFormField(
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
          onEditingComplete: () => submit(context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (name) {
            if (!submitted) return null;
            final controller = ref.read(signInControllerProvider.notifier);
            return controller.nameErrorText(name ?? '');
          },
        ),
      ],
      cta: [
        LoadingElevatedButton(
          isLoading: state.isLoading,
          onPressed: () => submit(context),
          text: 'Save'.hardcoded,
        ),
      ],
    );
  }
}
