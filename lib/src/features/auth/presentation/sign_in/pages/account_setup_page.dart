import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

class AccountSetupPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const AccountSetupPage({super.key, this.onSuccess});

  @override
  ConsumerState<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  // final formKey = GlobalKey<FormState>();
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

  void submit(BuildContext context) async {
    final controller = ref.read(signInControllerProvider.notifier);
    final success = await controller.submitAccount(name, null);
    if (success) widget.onSuccess?.call();
    nameNode
      ..nextFocus()
      ..unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    return SignInLayout(
      // formKey: formKey,
      title: 'Set up your profile'.hardcoded,
      description: 'Choose a name that others will recognize you.'.hardcoded,
      content: [
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
          isLoading: state.isLoading,
          onPressed: () => submit(context),
          text: 'Save'.hardcoded,
        ),
      ],
    );
  }
}
