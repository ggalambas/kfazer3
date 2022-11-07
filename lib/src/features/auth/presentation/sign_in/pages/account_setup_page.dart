import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';

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

  void submit() {
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
    ref.listen<AsyncValue>(
      signInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(signInControllerProvider);
    return SetupLayout(
      formKey: formKey,
      title: context.loc.profileSetUp,
      description: TextSpan(
        text: context.loc.profileSetUpDescription,
      ),
      content: [
        TextFormField(
          focusNode: nameNode,
          controller: nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          maxLength: kNameLength,
          decoration: InputDecoration(
            counterText: '',
            labelText: context.loc.displayName,
          ),
          onEditingComplete: submit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (name) {
            if (!submitted) return null;
            return ref
                .read(signInControllerProvider.notifier)
                .nameErrorText(context, name ?? '');
          },
        ),
      ],
      cta: [
        LoadingElevatedButton(
          loading: state.isLoading,
          onPressed: submit,
          child: Text(context.loc.save),
        ),
      ],
    );
  }
}
