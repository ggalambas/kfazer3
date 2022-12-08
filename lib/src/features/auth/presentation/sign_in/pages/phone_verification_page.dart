import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_setup.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';

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
      ref.read(smsCodeControllerProvider(phoneNumber).notifier).sendSmsCode();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      signInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(signInControllerProvider);
    final phoneNumber = ref.watch(signInPayloadProvider).phoneNumber!;
    return ResponsiveSetup(
      formKey: formKey,
      title: context.loc.phoneNumberVerification,
      description: context.loc.phoneNumberVerificationDescription(phoneNumber),
      content: TextFormField(
        focusNode: codeNode,
        controller: codeController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        maxLength: kCodeLength,
        decoration: InputDecoration(
          counterText: '',
          labelText: context.loc.code,
        ),
        onEditingComplete: submit,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (code) {
          if (!submitted) return null;
          return ref
              .read(signInControllerProvider.notifier)
              .codeErrorText(context, code ?? '');
        },
      ),
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final smsCodeController =
                ref.watch(smsCodeControllerProvider(phoneNumber));
            final timer = smsCodeController.value ?? 0;
            return LoadingOutlinedButton(
              loading: smsCodeController.isLoading,
              onPressed: state.isLoading || timer > 0
                  ? null
                  : () => resendSmsCode(phoneNumber),
              child: Text(
                '${context.loc.resendSms}${timer > 0 ? ' ($timer)' : ''}',
              ),
            );
          },
        ),
        LoadingElevatedButton(
          loading: state.isLoading,
          onPressed: submit,
          child: Text(context.loc.signIn),
        ),
      ],
    );
  }
}
