import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_edit_screen_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/website.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneSignInPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const PhoneSignInPage({super.key, this.onSuccess});

  @override
  ConsumerState<PhoneSignInPage> createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends ConsumerState<PhoneSignInPage> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberNode = FocusNode();
  final phoneNumberController = TextEditingController();
  PhoneCodeController? phoneCodeController;

  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController!.code;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    phoneCodeController?.dispose();
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  void submit() async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(signInControllerProvider.notifier);
    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    final success = await controller.submit(SignInPage.phone, phoneNumber);
    if (success) widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final countryListValue = ref.watch(countryListFutureProvider);
    return SignInLayout(
      formKey: formKey,
      title: context.loc.welcome,
      description: TextSpan(
        text: context.loc.welcomeDescription,
        children: [
          TextSpan(
            text: context.loc.termsOfService,
            style: TextStyle(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(Website.terms),
          ),
          TextSpan(text: ' ${context.loc.and} '),
          TextSpan(
            text: context.loc.privacyPolicy,
            style: TextStyle(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(Website.privacy),
          ),
        ],
      ),
      content: [
        AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) {
            phoneCodeController ??= PhoneCodeController.fromLocale(
              Localizations.localeOf(context),
              countryList,
            );
            return TextFormField(
              focusNode: phoneNumberNode,
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.loc.phoneNumber,
                prefix:
                    PhoneCodeDropdownPrefix(controller: phoneCodeController!),
              ),
              onEditingComplete: submit,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (phoneNumber) {
                if (!submitted) return null;
                return ref
                    .read(signInControllerProvider.notifier)
                    .phoneNumberErrorText(context, phoneNumber ?? '');
              },
            );
          },
        ),
      ],
      cta: [
        if (countryListValue.hasValue)
          LoadingElevatedButton(
            loading: state.isLoading,
            onPressed: submit,
            child: Text(context.loc.next),
          ),
      ],
    );
  }
}
