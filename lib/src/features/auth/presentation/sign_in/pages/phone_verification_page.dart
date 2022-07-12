import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

class PhoneVerificationPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const PhoneVerificationPage({super.key, this.onSuccess});

  @override
  ConsumerState<PhoneVerificationPage> createState() =>
      _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends ConsumerState<PhoneVerificationPage> {
  final formKey = GlobalKey<FormState>();
  final codeNode = FocusNode();
  final codeController = TextEditingController();

  String get code => codeController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    codeController.dispose();
    codeNode.dispose();
    super.dispose();
  }

  void submit(BuildContext context) async {
    codeNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(signInControllerProvider.notifier);
    final success = await controller.submit(SignInPage.verification, code);
    if (success) widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    return SignInLayout(
      formKey: formKey,
      title: 'Verifying your number'.hardcoded,
      //TODO get phoneNumber
      description: 'We have sent a code to +351912345678'.hardcoded,
      content: [
        //TODO add pinput package
        // Pinput(
        //   focusNode: codeNode,
        //   controller: codeController,
        //   length: 6,
        //   androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
        //   listenForMultipleSmsOnAndroid: true,
        //   defaultPinTheme: const PinTheme(),
        //   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        // ),
        TextFormField(
          focusNode: codeNode,
          controller: codeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Code'.hardcoded,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(kSpace),
            ),
          ),
          onEditingComplete: () => submit(context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (code) {
            if (!submitted) return null;
            final controller = ref.read(signInControllerProvider.notifier);
            return controller.codeErrorText(code ?? '');
          },
        ),
      ],
      cta: [
        //TODO resend sms code and timer
        OutlinedButton(
          onPressed: state.isLoading
              ? null
              : () => showNotImplementedAlertDialog(context: context),
          child: Text('Resend SMS (30)'.hardcoded),
        ),
        LoadingElevatedButton(
          isLoading: state.isLoading,
          onPressed: () => submit(context),
          text: 'Sign in'.hardcoded,
        ),
      ],
    );
  }
}
