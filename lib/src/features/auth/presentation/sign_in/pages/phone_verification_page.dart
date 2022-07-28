import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

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

  void submit() async {
    codeNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(signInControllerProvider.notifier);
    final success = await controller.submit(SignInPage.verification, code);
    if (success) widget.onSuccess?.call();
  }

  void resendSmsCode(PhoneNumber phoneNumber) =>
      ref.read(smsCodeControllerProvider(phoneNumber).notifier).resendSmsCode();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final phoneNumber =
        ref.watch(signInControllerProvider.notifier).phoneNumber!;
    return SignInLayout(
      formKey: formKey,
      title: 'Verifying your number'.hardcoded,
      description: TextSpan(
        text: 'We have sent a code to $phoneNumber'.hardcoded,
      ),
      content: [
        TextFormField(
          focusNode: codeNode,
          controller: codeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 6,
          decoration: InputDecoration(
            counterText: '',
            labelText: 'Code'.hardcoded,
          ),
          onEditingComplete: submit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (code) {
            if (!submitted) return null;
            return ref
                .read(signInControllerProvider.notifier)
                .codeErrorText(code ?? '');
          },
        ),
      ],
      cta: [
        Consumer(
          builder: (context, ref, _) {
            final smsCodeController =
                ref.watch(smsCodeControllerProvider(phoneNumber));
            final timer = smsCodeController.value ?? 0;
            return LoadingOutlinedButton(
              isLoading: smsCodeController.isLoading,
              onPressed: state.isLoading || timer > 0
                  ? null
                  : () => resendSmsCode(phoneNumber),
              child: Text(
                'Resend SMS${timer > 0 ? ' ($timer)' : ''}'.hardcoded,
              ),
            );
          },
        ),
        LoadingElevatedButton(
          isLoading: state.isLoading,
          onPressed: submit,
          child: Text('Sign in'.hardcoded),
        ),
      ],
    );
  }
}
